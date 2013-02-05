class RepliesController < ApplicationController
  def create
    comment = Comment.find(params[:comment_id])
    reply_text = params[:reply]
    user = current_user

    new_reply = Reply.new({
      :text => reply_text,
    })
    new_reply.user = user
    new_reply.comment = comment
    if new_reply.save == false
      render :nothing => true
      return
    end

    render :json => {
      id: comment.id,
      count: comment.replies.count,
      name: new_reply.user.name,
      user_url: user_tunes_path(user),
      reply_id: new_reply.id,
      date: new_reply.updated_at.strftime("%Y/%m/%d %H:%M"),
      reply_latest_date: comment.updated_at.strftime("%m/%d"),
      reply: reply_text,
      destroy_url: comment_reply_path(comment.id, new_reply.id)
    },
    :callback => 'addReply'

    EM::defer do
      begin
        send_mail_to_comment_owner(comment, new_reply)
        send_mail_to_comment_other(comment, new_reply)
      rescue => e
        logger.error e.class.name
        logger.error e.message
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
    return if !comment.user.notify
    return if comment.user == reply.user
    CommentMailer.to_owner(comment.user, comment, reply).deliver
  end

  def send_mail_to_comment_other(comment, reply)
    comment.replies.map{|r| r.user }.uniq.each{|u|
      next if !u.notify
      next if u == reply.user
      next if u == comment.user
      sleep 10
      CommentMailer.to_other(u, comment, reply).deliver
    }
  end
end
