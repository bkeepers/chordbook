class LookupMetadata < ApplicationJob
  include HTTParty
  API_KEY = ENV["THEAUDIODB_API_KEY"] || "2" # default public key
  base_uri "https://www.theaudiodb.com"
  raise_on 400..600

  delegate :get, :path, to: :class

  class_attribute :last_requested_at

  def perform(model, recursive: true, **args)
    send "sync_#{model.class.name.underscore}", model, recursive: recursive, **args
  end

  def sync_artist(artist, recursive: true, metadata: nil)
    # No new metadata provided, look it up
    unless metadata
      response = if artist.metadata
        # Artist was previously synced, but lookup by known id to refresh
        get "artist.php", query: {i: artist.metadata["idArtist"]}
      else
        # New artist, search and use first result
        get "search.php", query: {s: artist.name}
      end

      metadata = Array(response["artists"]).first
    end

    # Save new metadata
    artist.update metadata: metadata if metadata

    if recursive && metadata
      # Look up albums
      response = get "album.php", query: {i: metadata["idArtist"]}
      Array(response["album"]).each_with_index do |album_data, i|
        album = artist.albums.find_or_create_by!(title: album_data["strAlbum"]) do |a|
          a.metadata = album_data
        end

        # Album exists, update it with new metadata
        sync_album album, recursive: recursive, metadata: album_data
      end
    end
  end

  def sync_album(album, recursive: true, metadata: nil)
    unless metadata
      response = get "album.php", query: {i: album.artist.metadata["idArtist"]}
      metadata = response["album"].detect { |data| data["strAlbum"] == album.title }
    end

    album.update metadata: metadata

    if recursive
      response = get "track.php", query: {m: metadata["idAlbum"]}
      response["track"].each do |track_data|
        album.tracks.find_or_create_by!(title: track_data["strTrack"]) do |t|
          t.artist = album.artist
          t.metadata = track_data
        end
      end
    end
  end

  def self.get(path, *args)
    one_request_per_second
    super "/api/v1/json/#{API_KEY}/#{path}", *args
  end

  # FIXME: make this thread safe
  def self.one_request_per_second
    now = Time.now

    # Only allow 1 request/sec for this job
    if last_requested_at
      diff = now - last_requested_at
      sleep diff if diff < 1.0
    end

    self.last_requested_at = now
  end
end
