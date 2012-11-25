# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])

    comment = user.comments.build(params[:comment])
    comment.tune = tune
    comment.save!

    redirect_to user_tune_path(user,tune)
  end

  def destroy
    @comment_id = params[:id] # destroy.js.erb で使う
    Comment.find(@comment_id).destroy
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def ajax_create
    user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])

    comment = user.comments.build({"text" => params[:comment]})
    comment.tune = tune
    comment.save!

    render :json => { id:         tune.id,
                      comment_id: comment.id,
                      date:       comment.created_at.strftime("%Y/%m/%d %H:%M"),
                      comment:    comment.text
                    },
           :callback => 'addComment'
  end


end
