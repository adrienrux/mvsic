class Festival < ActiveRecord::Base
  validates :name, :location, :description, :start_date, :end_date, presence: true
  validate :end_date_is_after_start_date
  has_many :venues, lambda { order :name }, dependent: :destroy
  has_many :schedules

  private

  def end_date_is_after_start_date
    if end_date && start_date && end_date < start_date
      errors.add(:end_date, 'must be after start_date')
    end
  end
end
