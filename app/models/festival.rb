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
    artists = []

    events.pluck(:artist_id).each do |a_id|
      # Go straight into redis instead of iterating over Artist instances
      plays = $redis.get("artist-#{a_id}-user_play").to_i
      artists << { id: a_id, play_count: plays }
    end

    top = artists.sort_by { |a| a[:play_count] }.reverse.last(3)
    Artist.where(id: top.map { |a| a[:id] })
  end
end
