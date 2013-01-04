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
end
