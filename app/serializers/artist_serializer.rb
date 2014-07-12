class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :soundcloud_track_url
end
