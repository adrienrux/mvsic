class Venue < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :festival
  has_many :events, dependent: :destroy
end
