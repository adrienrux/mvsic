class BetaController < ApplicationController

  before_filter :mailchimp

  # POST /beta/signup
  def signup
    @mailchimp.subscribe(
      email: params[:email],
      first_name: params[:first_name],
      last_name: params[:last_name]
    )

    render json: { success: true }
  end

  private

  def mailchimp
    @mailchimp ||= Mailchimp.new(ENV['MAILCHIMP_API_KEY'])
  end


end
