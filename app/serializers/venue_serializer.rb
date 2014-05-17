class VenueSerializer < ActiveModel::VenueSerializer
  attributes :name
  has_many :events
end
