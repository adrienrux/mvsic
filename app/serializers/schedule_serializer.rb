class ScheduleSerializer < ActiveModel::Serializer
  attributes :id
  has_many :schedule_events, key: :schedule_events_attributes
end
