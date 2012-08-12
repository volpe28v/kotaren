class RankingController < ApplicationController
  def index
    @tune_ranking = Tune.get_tune_ranking
  end

  def players
    @user = current_user
    @tune = Tune.find(params[:tune_id])
    @progress_val = @tune.progress_val(@user)
    @comment = Comment.new
    @comments = @user.comments.by_tune(@tune)
    @other_comments = Comment.other_by(@user).by_tune(@tune)
    @other_member_count = Progress.includes(:tune).where("tunes.id = ? and percent > 0", @tune.id).count - ( @progress_val > 0 ? 1 : 0 )
  end

  def latest_played
    @progresses = Progress.order("updated_at DESC").limit(30)
  end
end
