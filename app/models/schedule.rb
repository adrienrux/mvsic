class Schedule < ActiveRecord::Base
  include HasHashedId

  belongs_to :festival
  belongs_to :user
  has_many :events, through: :schedule_events
  has_many :schedule_events, dependent: :destroy, inverse_of: :schedule

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :schedule_events, allow_destroy: true
end
