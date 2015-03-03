class Api::FestivalsController < Api::BaseController

  before_filter :verify_params
  before_filter :setup_params

  # GET /api/festivals.json
  def index
    @festivals = Festival.active
    render json: @festivals, each_serializer: FestivalSeedSerializer
  end

  # GET /api/festivals/id.json
  def show
    @festival = Festival.find(params[:id])
    render json: @festival
  end
end
