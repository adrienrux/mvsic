class CreateScheduleEvents < ActiveRecord::Migration
  def change
    create_table :schedule_events do |t|
      t.timestamps null: false
      t.datetime :deleted_at
      t.references :event, null: false, index: true
      t.references :schedule, null: false, index: true
    end
  end
end
