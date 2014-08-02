class FestivalSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :start_date, :end_date, :slug
  has_many :top_artists
  has_many :events

  def top_artists
    object.events.map(&:artist).sort_by{ |a| a.count :user_play }.reverse.first(3)
  end
end
