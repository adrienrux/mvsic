class Event < ActiveRecord::Base
  validates :start_time, :end_time, presence: true
  validate :end_time_is_after_start_time
  belongs_to :venue
  belongs_to :artist
  has_many :schedule_events, dependent: :destroy
  has_many :schedules, through: :schedule_events

  private

  def end_time_is_after_start_time
    if end_time && start_time && end_time < start_time
      errors.add(:end_time, 'must be after start_time')
    end
  end
end
