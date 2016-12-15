# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])

    @comment = @user.comments.build(params[:comment])
    @comment.tune = tune
    if @comment.save == false
      render :nothing => true
      return
    end

    if request.smart_phone?
      render :json => {
        comment: @comment,
        tune: tune,
        user: @user,
        replies: []
      }
    else
      render :json => {
        id: @comment.id,
        html: render_to_string(:partial => "comments/comment_body", :locals => { :c => @comment })
      }
    end
    EM::defer do
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          send_mail_to_other(@comment)
        rescue => e
          logger.error e.class.name
          logger.error e.message
        end
      end
    end
  end

  def destroy
    @comment_id = params[:id] # destroy.js.erb で使う
    Comment.find(@comment_id).destroy
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def load_comment_list
    @comments = Comment.order("updated_at DESC").limit(30)

    lists = render_to_string :partial => 'comment_list_smart_phone'
    render :json => { lists: lists },
           :callback => 'showCommentList'
  end

  private
  def send_mail_to_other(comment)
    send_users = User.all.select{|u| u.all_notify}
    send_users.each{|u|
      next if u == comment.user
      sleep 10
      CommentMailer.to_other_with_comment(u, comment).deliver
    }
  end


end
