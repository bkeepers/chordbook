class Album < ApplicationRecord
  include Metadata
  include PgSearch::Model

  belongs_to :artist
  belongs_to :genre, optional: true
  has_many :tracks, -> { Track.order_by_number }, dependent: :destroy
  has_many :library_items, as: :item, dependent: :destroy

  before_validation :associate_genre, :validate_released_year

  scope :order_by_popular, -> { order("albums.rank") }
  scope :order_by_released, ->(dir = :desc) { order(released: "#{dir} NULLS LAST") }

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  scope :search_import, -> { includes(:artist, :image_attachment) }

  attach_from_metadata image: [:strAlbumThumbHQ, :strAlbumThumb]

  map_metadata(
    strAlbumThumb: :thumbnail,
    intYearReleased: :released,
    strStyle: :style,
    strDescriptionEN: :description,
    intScore: :score
  )

  def search_data
    {
      type: self.class,
      title: title,
      thumbnail: thumbnail,
      attachment_id: image_attachment&.id,
      subtitle: artist.name,
      everything: [title, artist.name],
      boost: 1.0
    }
  end

  def associate_genre
    self.genre ||= if metadata["strGenre"].present?
      Genre.find_or_create_by!(name: metadata["strGenre"])
    else
      # Fall back to artist genre
      artist.genre
    end
  end

  def validate_released_year
    # Source data is bad for a handful of albums
    self.released = nil unless (1900..Date.today.year).cover?(released)
  end
end
