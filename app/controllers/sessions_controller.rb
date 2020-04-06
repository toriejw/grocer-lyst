class SessionsController < ApplicationController
  skip_before_action :authorize!, only: [:new, :create, :destroy]

  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
       session[:user_id] = user.id
       redirect_to user_path(user)
    else
       flash.alert = "Invalid login credentials"
       redirect_to login_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
