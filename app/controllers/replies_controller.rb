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
