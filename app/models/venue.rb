class Venue < ActiveRecord::Base
  validates :name, presence: true
  has_many :events
  belongs_to :festival
end
