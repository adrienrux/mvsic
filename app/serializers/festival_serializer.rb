class FestivalSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :description, :start_date, :end_date, :slug, :current_state, :twitter_handle, :website, :background_image
  has_many :top_artists
  has_many :events

  def start_date
    object.start_date.strftime '%B %-d, %Y'
  end

  def end_date
    object.start_date.strftime '%B %-d, %Y'
  end

  def background_image
    file_names = Dir.entries('app/assets/images/wallpaper/random').select do |name|
      name.match /\.[je?pg|png]/
    end

    "/assets/wallpaper/random/#{file_names.sample}"
  end
end
