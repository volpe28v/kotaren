class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to user_tunes_path(current_user)
  end

  def show
  end

end
