class EventSerializer < ActiveModel::Serializer
  attributes :id, :artist, :start_time, :end_time, :venue_name

  def venue_name
    object.venue.name
  end
end
