class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :venues, index: true
      t.references :artists, index: true
    end
  end
end
