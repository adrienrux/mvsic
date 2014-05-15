class Festival < ActiveRecord::Base
  validates :name, :location, :description, :start_date, :end_date, presence: true
  has_many :venues
end
