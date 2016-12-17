class RepliesController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    user = current_user

    new_reply = Reply.new(reply_params)
    new_reply.user = user
    new_reply.comment = comment
    unless new_reply.save
      render :nothing => true
      return
    end

    if request.smart_phone?
      render :json => {
        id: new_reply.id,
        text: new_reply.text,
        updated_at: new_reply.updated_at,
        user: new_reply.user
      }
    else
      render :json => {
        id: new_reply.id,
        html: render_to_string(:partial => "replies/reply_body", :locals => { :c => comment, :r => new_reply })
      }
    end

    EM::defer do
      ActiveRecord::Base.connection_pool.with_connection do
        begin
          send_mail_to_comment_owner(comment, new_reply)
          send_mail_to_comment_other(comment, new_reply)
        rescue => e
          logger.error e.class.name
          logger.error e.message
        end
      end
    end
  end

  def destroy
    Reply.find(params[:id]).destroy
    if request.smart_phone?
      comment = Comment.find(params[:comment_id])

      render :json => {
        id: comment.id,
        reply_latest_date: comment.updated_at.strftime("%m/%d"),
        count: comment.replies.count
      },
      :callback => 'removeReply'
    else
      @reply_id = params[:id] # destroy.js.erb で用いる
    end
  end

  private
  def send_mail_to_comment_owner(comment, reply)
    return if (!comment.user.notify and !comment.user.all_notify)
    return if comment.user == reply.user
    CommentMailer.to_owner(comment.user, comment, reply).deliver
  end

  def send_mail_to_comment_other(comment, reply)
    send_users = User.all.select{|u| u.all_notify}
    comment.replies.map{|r| r.user }.each{|u|
      next if !u.notify
      send_users << u
    }

    send_users.uniq.each{|u|
      next if u == reply.user
      next if u == comment.user
      sleep 10
      CommentMailer.to_other(u, comment, reply).deliver
    }
  end

  def reply_params
    params.require(:reply).permit(
      :text
    )
  end
end
