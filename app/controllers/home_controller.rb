class HomeController < ApplicationController
  skip_before_action :authorize!

  def index
    if current_user
      redirect_to user_path(current_user)
    end
  end
end
