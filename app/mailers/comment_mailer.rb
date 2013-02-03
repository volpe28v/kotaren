# coding: utf-8
class CommentMailer < ActionMailer::Base
  default from: "コタれん <#{ENV['MAIL_ADDRESS']}>"

  def add_comment(user, comment, reply)
    return if !user.notify

    @user = user
    @comment = comment
    @reply = reply

    mail(to: @user.email,
         subject: "#{@user.name}さんのコメントに返信がありました！")
  end
end
