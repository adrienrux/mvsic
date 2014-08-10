class BetaController < ApplicationController

  before_filter :mailchimp, only: [:signup]
  before_filter :create_user, only: [:signup]

  # POST /beta/signup
  def signup
    begin
      @mailchimp.subscribe(email: @user.email, first_name: @user.first_name, last_name: @user.last_name)
      render json: { success: true }, status: :created
    rescue Gibbon::MailChimpError => e
      render json: { error: e.name, status: e.code }, status: e.code
    end
  end

  # POST /beta/feedback
  def feedback
    UserMailer.feedback_email(params[:name], params[:email], params[:message]).deliver
    render json: { success: true }
  end

  private

  def mailchimp
    @mailchimp ||= Mailchimp.new(ENV['MAILCHIMP_API_KEY'])
  end

  def create_user
    @user = User.where(email: params[:email], first_name: params[:first_name], last_name: params[:last_name]).first_or_create
  end
end
