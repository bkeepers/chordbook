class Track < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  belongs_to :artist
  belongs_to :album, optional: true
  belongs_to :genre, optional: true

  has_many :songsheets, dependent: :nullify

  scope :order_by_popular, -> { order("tracks.has_songsheet, tracks.listeners DESC NULLS LAST") }
  scope :with_songsheet, -> { where(has_songsheet: true) }
  scope :title_like, -> (title) { where("LOWER(title) = LOWER(:title)", title: title.strip) }

  before_validation :associate_genre
  after_create :associate_songsheets

  multisearchable additional_attributes: ->(record) { record.searchable_data },
    unless: :has_songsheet? # No need to index tracks with songsheets

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def searchable_text
    [title, artist&.name, album&.title].compact.join(" ")
  end

  def searchable_data
    {
      weight: 0.25,
      data: {
        title: title,
        subtitle: artist.name,
        thumbnail: album&.thumbnail
      }
    }
  end

  def has_songsheet!
    update_attribute :has_songsheet, true
  end

  def associate_songsheets
    Songsheet.joins(:artists)
      .where(artists: artist)
      .where(songsheets: {title: title})
      .update(track: self)
  end

  def associate_genre
    return if metadata["strGenre"].blank?
    self.genre = Genre.find_or_create_by!(name: metadata["strGenre"])
  end
end
