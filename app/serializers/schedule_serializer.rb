class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :hashed_id
  has_one :festival
  has_many :schedule_events, key: :schedule_events_attributes
end
