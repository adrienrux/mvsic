class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :soundcloud_track_url, :play_count

  def play_count
    object.count :user_play
  end
end
