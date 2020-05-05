class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_conversations
  include SessionsHelper

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def get_conversations
    if logged_in?
      session[:conversations] ||= []
      @conversations = Conversation.includes(:messages).find(session[:conversations])
    end
  end
  
end
