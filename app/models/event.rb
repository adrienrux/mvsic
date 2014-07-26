class Event < ActiveRecord::Base
  belongs_to :festival
  belongs_to :artist
  has_one :venue
  has_many :schedule_events, dependent: :destroy
  has_many :schedules, through: :schedule_events
end
