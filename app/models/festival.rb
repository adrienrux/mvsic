class Festival < ActiveRecord::Base
  validates :name, :location, :start_date, :end_date, presence: true
  has_many :venues
  has_many :events
  has_many :schedules

  scope :active, -> { where(active: true) }
  scope :after, -> (time) { where('start_date > ?', time) }
  scope :before, -> (time) { where('start_date < ?', time) }

  def slug
    "#{name.parameterize}-#{start_date.year}"
  end

  def current_state
    if events.pluck(:start_time).compact.empty?
      # True if there all start_date values are nil
      'lineup'
    else
      'schedule'
    end
  end

  def top_artists
    events.map(&:artist).sort_by{ |a| a && a.count(:user_play) }.reverse.first(3)
  end
end
