class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to user_tunes_path(current_user)
  end

  def show
  end

  def edit
    @user = current_user;
    @user.name ||= @user.default_name

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])

    else
      render :action => "edit"
    end
  end

  def list
    @users = User.all

  end

end
