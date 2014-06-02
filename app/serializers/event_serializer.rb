class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :venue_name
  has_one :artist

  def venue_name
    object.venue.name
  end
end
