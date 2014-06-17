class ScheduleSerializer < ActiveModel::Serializer
  attributes :id
  has_one :festival
  has_many :schedule_events, key: :schedule_events_attributes
end
