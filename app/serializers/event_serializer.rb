class EventSerializer < ActiveModel::Serializer
  attributes :end_time, :date, :id, :start_time, :venue_name
  has_one :artist

  def venue_name
    object.venue.name
  end

  def date
    object.start_time.strftime('%A, %m-%e-%Y')
  end
end
