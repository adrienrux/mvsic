RailsAdmin.config do |config|
  config.authorize_with do
    authenticate_or_request_with_http_basic('Site Message') do |username, password|
      username == 'divu' && password == 'isgettingmarried'
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.model 'Artist' do
    list do
      items_per_page 100
      field :name
      field :play_count
      field :schedule_count
      field :soundcloud_url
      field :soundcloud_track_url
    end
  end

  config.model 'Event' do
    object_label_method do
      :event_label
    end

    list do
      items_per_page 100
    end

    edit do
      field :festival
      field :venue
      field :artist
      field :start_time
      field :end_time
    end
  end

  config.model 'Festival' do
    edit do
      field :name
      field :location
      field :website
      field :twitter_handle
      field :description
      field :start_date
      field :end_date
      field :active
      field :show_schedule
      field :image_file
    end
  end

  config.model 'Venue' do
    object_label_method do
      :venue_label
    end
  end

  def play_count
    self.count('user_play')
  end

  def schedule_count
    self.count('user_save_to_schedule')
  end

  def event_label
    if self.start_time && self.end_time
      "#{self.festival.name}: #{self.artist.name} (#{self.start_time.strftime('%-m/%-d/%Y %l:%M %p')})"
    else
      "#{self.festival.name}: #{self.artist.name}"
    end
  end

  def venue_label
    "#{self.festival.name}: #{self.name}"
  end
end
