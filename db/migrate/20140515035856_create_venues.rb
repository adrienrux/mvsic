class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.references :event, index: true
      t.references :festival, index: true
    end
  end
end
