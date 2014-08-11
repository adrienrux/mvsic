class CreateFestivals < ActiveRecord::Migration
  def change
    create_table :festivals do |t|
      t.string :name
      t.string :location
      t.string :website
      t.string :twitter_handle
      t.text   :description
      t.date   :start_date
      t.date   :end_date
      t.boolean :active
      t.timestamps
    end
  end
end
