class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u|
      u.permit(
        :name, :email,
        :password, :password_confirmation,
        :twitter_name, :youtube_name, :guitar, :tuning
      )
    }
  end
end
