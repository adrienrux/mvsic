class Venue < ActiveRecord::Base
  validates :name, presence: treu
  belongs_to :festival
  has_many :events
end
