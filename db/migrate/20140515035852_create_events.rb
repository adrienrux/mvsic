class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :festival, index: true
      t.references :venue, index: true
      t.references :artist, index: true
      t.timestamps
    end
  end
end
