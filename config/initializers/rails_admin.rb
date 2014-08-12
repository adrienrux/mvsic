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

  config.model 'Event' do
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

  config.model 'Tracker' do
    object_label_method do
      :artist_name
    end

    list do
      field :artist_name
      field :subject
      field :count
    end

    edit do
      field :artist_name
      field :subject
      field :count
    end
  end

  def artist_name
    self.instance.name
  end
end
