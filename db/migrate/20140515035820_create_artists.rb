class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :soundcloud_url
      t.string :soundcloud_track_url
    end
  end
end
