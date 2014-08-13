class FestivalSeedSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :slug, :current_state, :timestamp
  has_many :top_artists

  def timestamp
    "#{object.start_date.strftime('%b %-d')} - #{object.end_date.strftime('%b %-d, %Y')}"
  end
end
