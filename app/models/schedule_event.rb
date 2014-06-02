class ScheduleEvent < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :event

  validates :event, presence: true
  validates :schedule, presence: true
  validates :event_id, uniqueness: { scope: %i(schedule_id deleted_at) }
end
