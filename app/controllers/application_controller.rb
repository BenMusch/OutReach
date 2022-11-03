class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?

  def index
    redirect_to 'http://outreach.vote'
  end

  def authorized
    redirect_to '/' unless logged_in?
  end

  def logged_in?
    !current_user.nil? && !session[:is_verifying].present?
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      nil
    end
  end
end
