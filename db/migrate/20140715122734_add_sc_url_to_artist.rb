class AddScUrlToArtist < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.string :soundcloud_track_url
    end
  end
end
