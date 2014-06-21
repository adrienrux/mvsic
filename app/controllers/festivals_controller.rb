class FestivalsController < ApplicationController
  # Formats
  respond_to :html

  def index
    @festivals = Festival.all
  end

  def show
    @festival = Festival.find(params[:id])
  end
end
