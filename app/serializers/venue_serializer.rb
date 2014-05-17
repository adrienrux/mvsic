class VenueSerializer < ActiveModel::Serializer
  attributes :name
  has_many :events
end
