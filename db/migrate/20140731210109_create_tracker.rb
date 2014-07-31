class CreateTracker < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :instance_class, null: false, index: true
      t.integer :instance_id, null: false, index: true
      t.string :subject, null: false
      t.integer :count, default: 0
    end
  end
end
