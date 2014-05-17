class AngularController < ApplicationController
  # Formats
  respond_to :html

  def index
    render 'layouts/angular.html'
  end
end
