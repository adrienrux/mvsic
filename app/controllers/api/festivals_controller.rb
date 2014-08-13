class Api::FestivalsController < Api::BaseController

  before_filter :verify_params
  before_filter :setup_params

  # GET /api/festivals.json
  def index
    @festivals = apply_params(Festival.active.after(Time.zone.now.beginning_of_day))
    render json: @festivals, each_serializer: FestivalSeedSerializer
  end

  # GET /api/festivals/id.json
  def show
    @festival = Festival.find(params[:id])
    render json: @festival
  end
end
