class FestivalSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :start_date, :end_date
  has_many :top_artists
  has_many :events

  def top_artists
    object.events.sample(3).map(&:artist)
  end
end
