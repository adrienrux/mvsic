class AddHashedIdToSchedule < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.string :hashed_id
    end

    add_index :schedules, :hashed_id
  end
end
