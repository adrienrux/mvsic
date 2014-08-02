class Festival < ActiveRecord::Base
  validates :name, :location, :start_date, :end_date, presence: true
  has_many :venues
  has_many :events
  has_many :schedules

  scope :after, -> (time) { where('start_date > ?', time) }
  scope :before, -> (time) { where('start_date < ?', time) }

  def slug
    "#{name.parameterize}-#{start_date.year}"
  end
end
