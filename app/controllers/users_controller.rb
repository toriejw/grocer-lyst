class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      flash.alert = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
