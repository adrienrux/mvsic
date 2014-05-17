class Venue < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :festival
  has_many :events, order: 'events.start_time', dependent: :destroy
end
