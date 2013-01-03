# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])

    @comment = @user.comments.build(params[:comment])
    @comment.tune = tune
    @comment.save!
    @comment_html = render_to_string(:partial => 'comment_body', :locals => {:c => @comment}).gsub(/\n/,"").gsub(/"/,"\\\"");
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

  def load_comment_list
    @albums = Album.scoped.order("id ASC")
    @comments = Comment.scoped.order("updated_at DESC").limit(30)

    lists = render_to_string :partial => 'comment_list_smart_phone'
    render :json => { lists: lists },
           :callback => 'showCommentList'
  end
end
