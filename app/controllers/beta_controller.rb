class BetaController < ApplicationController

  before_filter :mailchimp

  # POST /beta/signup
  def signup
    begin
      @mailchimp.subscribe(email: params[:email], first_name: params[:first_name], last_name: params[:last_name])
      render json: { success: true }, status: :created
    rescue Gibbon::MailChimpError => e
      render json: { error: e.name, status: e.code }, status: e.code
    end
  end

  private

  def mailchimp
    @mailchimp ||= Mailchimp.new(ENV['MAILCHIMP_API_KEY'])
  end
end
