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

  def destroy
    @comment_id = params[:id] # destroy.js.erb で使う
    Comment.find(@comment_id).destroy
  end

end
