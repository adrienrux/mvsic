class Event < ActiveRecord::Base
  validates :start_time, :end_time, presence: true
  belongs_to :venue
  belongs_to :artist
end
