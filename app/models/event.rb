class Event < ActiveRecord::Base
  belongs_to :festival
  belongs_to :artist
  belongs_to :venue
  validates :artist, presence: true
  validates :festival, presence: true
  has_many :schedule_events, dependent: :destroy
  has_many :schedules, through: :schedule_events
end
