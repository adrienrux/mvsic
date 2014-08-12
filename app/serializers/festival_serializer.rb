class FestivalSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :start_date, :end_date, :slug, :current_state, :twitter_handle, :website, :background_image, :show_schedule
  has_many :top_artists
  has_many :events

  def start_date
    object.start_date.strftime '%B %-d, %Y'
  end

  def end_date
    object.end_date.strftime '%B %-d, %Y'
  end

  def background_image
    "/assets/wallpaper/festivals/#{object.image_file}"
  end
end
