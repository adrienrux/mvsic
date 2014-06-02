class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
