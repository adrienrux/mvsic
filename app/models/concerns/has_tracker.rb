require 'active_support/concern'

module HasTracker
  extend ActiveSupport::Concern

  # Return the specified subject counter for this object.
  # e.g. artist.count(:user_play)
  #      => 21
  def count(subject)
    $redis.get(key(subject)).to_i
  end

  # Increment the specified subject for this object.
  def increment!(subject, val = 1)
    $redis.incrby(key(subject), val)
  end

  def key(subject)
    "#{self.class.to_s.parameterize}-#{self.id}-#{subject}"
  end
end
