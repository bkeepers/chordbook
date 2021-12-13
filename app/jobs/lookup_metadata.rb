class LookupMetadata < ApplicationJob
  include HTTParty
  API_KEY = ENV["THEAUDIODB_API_KEY"]
  base_uri "https://www.theaudiodb.com"

  delegate :get, :path, to: :class

  def perform(model, recursive: model.id_previously_changed?, **args)
    send "sync_#{model.class.name.underscore}", model, recursive: recursive, **args
  end

  def sync_artist(artist, recursive: false, metadata: nil)
    # No new metadata provided, look it up
    unless metadata
      if artist.metadata
        # Artist was previously synced, but lookup by known id to refresh
        response = get path("artist.php"), query: { i: artist.metadata["idArtist"] }
      else
        # New artist, search and use first result
        response = get path("search.php"), query: { s: artist.name }
      end

      metadata = response["artists"].first
    end

    # Save new metadata
    artist.update metadata: metadata

    if recursive
      # Look up albums
      response = get path("album.php"), query: { i: metadata["idArtist"] }
      response["album"].each_with_index do |album_data, i|
        album = artist.albums.find_or_create_by!(title: album_data["strAlbum"]) do |a|
          a.metadata = album_data
        end

        # Album exists, update it with new metadata
        LookupMetadata.set(wait: (i + 1).seconds).perform_later album, recursive: recursive, metadata: album_data
      end
    end
  end

  def sync_album(album, recursive: artist.id_previously_changed?, metadata: nil)
    unless metadata
      response = get path("album.php"), query: { i: album.artist.metadata["idArtist"] }
      metadata = response["album"].detect { |data| data["strAlbum"] == album.title }
    end

    album.update metadata: metadata
  end

  def self.path(path)
    "/api/v1/json/#{API_KEY}/#{path}"
  end
end