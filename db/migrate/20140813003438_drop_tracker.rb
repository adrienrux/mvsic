class DropTracker < ActiveRecord::Migration
  def change
    drop_table :trackers
  end
end
