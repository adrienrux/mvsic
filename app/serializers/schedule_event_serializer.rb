class ScheduleEventSerializer < ActiveModel::Serializer
  attributes :id, :event_id
  has_one :event
end
