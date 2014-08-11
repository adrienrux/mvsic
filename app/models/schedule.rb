class Schedule < ActiveRecord::Base
  include HasHashedId

  belongs_to :festival
  belongs_to :user
  has_many :events, through: :schedule_events
  has_many :schedule_events, dependent: :destroy, inverse_of: :schedule

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :schedule_events, allow_destroy: true

  after_create :increment_counter

  def increment_counter
    events.map(&:artist).each do |artist|
      artist.increment :user_save_to_schedule
    end
  end
end
