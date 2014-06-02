class Api::FestivalsController < Api::BaseController

  before_filter :verify_params
  before_filter :setup_params

  # GET /api/festivals.json
  def index
    @festivals = apply_params(Festival)
    render json: @festivals
  end

  # GET /api/festivals/id.json
  def show
    @festival = Festival.find(params[:id])
    render json: @festival
  end
end
