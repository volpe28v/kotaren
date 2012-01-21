class WelcomeController < ApplicationController
  def index
    @user_count = User.count
  end

end
