class Venue < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :festival
  belongs_to :event
end
