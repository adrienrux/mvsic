class EventSerializer < ActiveModel::Serializer
  attributes :end_time, :date, :id, :start_time
  has_one :artist
  has_one :venue

  def date
    if object.start_time
      object.start_time.strftime('%A, %m-%e-%Y')
    end
  end
end
