class UsersController < ApplicationController
  skip_before_action :authorize!, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      flash.alert = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
