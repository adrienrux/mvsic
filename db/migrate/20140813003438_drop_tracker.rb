class DropTracker < ActiveRecord::Migration
  def change
    Tracker.where(subject: 'user_play').each do |tracker|
      tracker.instance.increment! 'user_play', tracker.count
    end

    drop_table :trackers
  end
end
