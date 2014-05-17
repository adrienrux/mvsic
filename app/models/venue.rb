class Venue < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :festival
  has_many :events, lambda { order :start_time }, dependent: :destroy
end
