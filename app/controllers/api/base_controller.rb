class Api::BaseController < ApplicationController

  private
  def verify_params
    head :bad_request and return if params[:id] && params[:id].match(/\D/)
    head :bad_request and return if params[:page] && params[:page].match(/\D/)
    head :bad_request and return if params[:per_page] && params[:per_page].match(/\D/)
    head :bad_request and return if params[:sort_order] && !params[:sort_order].match(/^(asc|desc)$/i)
    head :bad_request and return if params[:sort_by] && !params[:sort_by].match(/^(name|start_time|end_time|start_date|end_date)$/i)
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

  def render_validation_errors(model)
    render json: { error: model.errors.full_messages }, status: :unprocessable_entity
  end
end
