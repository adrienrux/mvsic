class Artist < ActiveRecord::Base
  include HasTracker

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :events, lambda { order :start_time }
end
