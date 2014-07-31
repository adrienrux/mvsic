class Artist < ActiveRecord::Base
  include TrackedModel

  validates :name, presence: true
  has_many :events, lambda { order :start_time }

  private
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
