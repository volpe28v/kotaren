class RankingController < ApplicationController
  def index
    @tune_ranking = Tune.all.inject([]){|touch,tune| touch << [tune, tune.progresses.where("percent > 0").count] }.sort{|a,b| b[1] <=> a[1]}
  end

end
