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

  def load_comment_list
    @albums = Album.scoped.order("id ASC")
    @comments = Comment.scoped.order("updated_at DESC").limit(50)

    lists = render_to_string :partial => 'comment_list_smart_phone'
    render :json => { lists: lists },
           :callback => 'showCommentList'
  end

  def ajax_create_reply
    comment = Comment.find(params[:comment_id])
    reply_text = params[:reply]
    user = current_user

    new_reply = Reply.new({
      :text => reply_text,
    })
    new_reply.user = user
    new_reply.comment = comment
    new_reply.save!

    render :json => {
      id: comment.id,
      name: new_reply.user.name,
      reply_id: new_reply.id,
      date: new_reply.updated_at.strftime("%Y/%m/%d %H:%M"),
      reply: reply_text
    },
    :callback => 'addReply'
  end
end
