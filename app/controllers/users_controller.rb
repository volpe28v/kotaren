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
    if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
      @user.name = params[:user][:name]
      @user.email = params[:user][:email]
      @user.youtube_name = params[:user][:youtube_name]
      @user.twitter_name = params[:user][:twitter_name]
      @user.guitar = params[:user][:guitar]
      @user.tuning = params[:user][:tuning]

      if @user.save
        redirect_to user_tunes_path(current_user)
      else
        render "edit"
      end
    else
      if @user.update_attributes(params[:user]) != true
        render "edit"
      end
    end
  end

  def list
    @users = User.order("created_at DESC")
  end

end
