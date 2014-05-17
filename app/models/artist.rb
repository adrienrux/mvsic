class Artist < ActiveRecord::Base
  validates :name, presence: true
  has_many :events, lambda { order :start_time }
end
