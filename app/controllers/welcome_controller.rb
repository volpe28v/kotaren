class WelcomeController < ApplicationController
  def index
    @user_count = User.count
    @tune_ranking = Tune.get_tune_ranking.limit(11)
  end
end
