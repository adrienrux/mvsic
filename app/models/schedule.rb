class Schedule < ActiveRecord::Base
  has_many :events, through: :schedule_events
  has_many :schedule_events, dependent: :destroy, inverse_of: :schedule

  accepts_nested_attributes_for :schedule_events, allow_destroy: true
end
