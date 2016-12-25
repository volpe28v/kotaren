class RankingController < ApplicationController
  def index
    @tune_ranking = Tune.get_tune_ranking.preload(:progresses, :tuning)
  end

  def latest_played
    @progresses = Progress.order("updated_at DESC").limit(50)
  end
end
