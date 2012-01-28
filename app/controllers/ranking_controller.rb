class RankingController < ApplicationController
  def index
    @tune_ranking = Tune.get_tune_ranking
  end
end
