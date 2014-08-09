class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :hashed_id, index: true
      t.belongs_to :festival, index: true
      t.timestamps
    end
  end
end
