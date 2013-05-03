# coding: utf-8
class CommentMailer < ActionMailer::Base
  helper :application
  default from: "コタれん <#{ENV['MAIL_ADDRESS']}>"

  def to_owner(user, comment, reply)
    @user = user
    @comment = comment
    @reply = reply

    mail(to: @user.email,
         subject: "#{@user.name}さんのコメントに返信がありました！")
  end

  def to_other(user, comment, reply)
    @user = user
    @comment = comment
    @reply = reply

    mail(to: @user.email,
         subject: "#{@user.name}さんに関連のあるコメントに返信がありました！")
  end
end
