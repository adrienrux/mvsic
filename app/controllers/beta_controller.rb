class BetaController < ApplicationController

  before_filter :mailchimp

  # POST /beta/signup
  def signup
    @mailchimp.subscribe(params[:email])
  end

  private

  def mailchimp
    @mailchimp ||= Mailchimp.new('b26d7c09336dd957ae08c9d716ccd3ed-us8')
  end


end
