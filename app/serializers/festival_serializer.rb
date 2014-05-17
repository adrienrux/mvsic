class FestivalSerializer < ActiveModel::Serializer
  attributes :name, :location, :description, :start_date, :end_date
  has_many :venues
end
