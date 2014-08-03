class AddSoundcloudUrlToArtist < ActiveRecord::Migration
  def change
    change_table :artists do |t|
      t.string :soundcloud_url
    end
  end
end
