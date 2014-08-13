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
    object_label_method do
      :play_count
      :schedule_count
    end

    list do
      field :name
      field :play_count
      field :schedule_count
      field :soundcloud_url
      field :soundcloud_track_url
    end
  end

  config.model 'Event' do
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

  def play_count
    self.count('user_play')
  end

  def schedule_count
    self.count('user_save_to_schedule')
  end
end
