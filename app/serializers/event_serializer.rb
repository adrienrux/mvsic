class EventSerializer < ActiveModel::Serializer
  attributes :id, :artist, :start_time, :end_time
end
