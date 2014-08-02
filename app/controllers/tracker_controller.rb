class TrackerController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_filter :verify_request

  # POST /track.json
  def update
    artist = Artist.where(id: params[:artist_id].to_i).first

    if artist
      artist.increment! params[:subject]
      render json: { count: artist.count(params[:subject]) }
    else
      render json: { errors: ['Artist not found'] }, status: 422
    end
  end

  private

  def verify_request
    head :bad_request and return if params[:artist_id] && params[:artist_id].to_s.match(/\D/)
    head :bad_request and return if params[:subject] && !params[:subject].match(/^(user_play|user_save_to_schedule)$/i)
  end
end
