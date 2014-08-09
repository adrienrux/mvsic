class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :hashed_id
  has_one :festival
  has_many :schedule_events, key: :schedule_events_attributes

  def schedule_events
    object.schedule_events.sort_by { |se| se.event.start_time }
  end
end
