class CommentsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])

    comment = Comment.create(params[:comment])
    user.comments << comment
    tune.comments << comment
    comment.save
    redirect_to user_tune_path(user,tune)
  end

end
