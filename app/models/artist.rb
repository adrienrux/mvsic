class Artist < ActiveRecord::Base
  include HasTracker

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  has_many :events, lambda { order :start_time }

  def create_trackers
    Tracker.create(
      instance_class: self.class.to_s,
      instance_id: self.id,
      subject: 'user_play'
    )
    Tracker.create(
      instance_class: self.class.to_s,
      instance_id: self.id,
      subject: 'user_save_to_schedule'
    )
  end
end
