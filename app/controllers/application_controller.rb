class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  before_action :authorized
  before_action :authorize_mini_profiler

  def authorized
    redirect_to '/login' unless logged_in?
  end

  def logged_in?
    !current_user.nil? && !session[:is_verifying].present?
  end

  def authorize_mini_profiler
    if current_user && current_user.is_admin
      Rack::MiniProfiler.authorize_request
    else
      Rack::MiniProfiler.deauthorize_request
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      nil
    end
  end
end
