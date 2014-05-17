class DataController < ApplicationController

  before_filter :verify_params
  before_filter :setup_params

  # GET /festivals.json
  def festivals
    @festivals = apply_params(Festival)
    render json: @festivals
  end

  private

  def verify_params
    head :bad_request and return if params[:page] && params[:page].match(/\D/)
    head :bad_request and return if params[:per_page] && params[:per_page].match(/\D/)
    head :bad_request and return if params[:sort_order] && !params[:sort_order].match(/^(asc|desc)$/i)
    head :bad_request and return if params[:sort_by] && !params[:sort_by].match(/^(name|start_time|end_time|)$/i)
  end

  def setup_params
    @params = {
      page: (params[:page] || 1).to_i,
      per_page: (params[:per_page] || 20).to_i,
      sort_by: params[:sort_by] || 'name',
      sort_order: params[:sort_order] || 'asc'
    }
  end

  def apply_params(objects)
    objects.order("#{@params[:sort_by]} #{@params[:sort_order]}")
      .page(@params[:page]).limit(@params[:per_page])
  end

end
