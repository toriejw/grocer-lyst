class ApplicationController < ActionController::Base
  before_action :authorize!

  helper_method :current_user

  def authorize!
    redirect_to login_path unless authorized?
  end

  def authorized?
    logged_in? && (current_user.id == params[:user_id].to_i)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end
