class WelcomeController < ApplicationController
  def index
    @user_count = User.count - 1
  end

end
