require 'active_support/concern'

module HasTracker
  extend ActiveSupport::Concern

  included do
    after_create :create_trackers
  end

  # Return the specified subject counter for this object.
  # e.g. artist.count(:user_play)
  #      => 21
  def count(subject)
    Tracker.for(self, subject).count
  end

  # Increment the specified subject for this object.
  def increment!(subject)
    Tracker.for(self, subject).try :increment!
  end

  private
  def create_trackers
    raise 'Implement in class that includes HasTracker'
  end
end
