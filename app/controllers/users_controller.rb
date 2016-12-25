class UsersController < ApplicationController
  before_action :authenticate_user!, :expect => [:edit, :update]

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
    if user_params[:password].blank? and user_params[:password_confirmation].blank?
      if @user.update_without_password(user_params)
        redirect_to user_tunes_path(current_user)
      else
        render "edit"
      end
    else
      if @user.update(user_params)
        redirect_to user_tunes_path(current_user)
      else
        render "edit"
      end
    end
  end

  def list
    @users = User.order("created_at DESC")
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :notify,
      :all_notify,
      :twitter_name,
      :youtube_name,
      :icon_url,
      :guitar,
      :tuning
    )
  end
end
