class EventSerializer < ActiveModel::Serializer
  attributes :artist, :start_time, :end_time
end
