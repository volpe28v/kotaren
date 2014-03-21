# coding: utf-8
class CommentMailer < ActionMailer::Base
  helper :application
  default from: "コタれん <#{ENV['MAIL_ADDRESS']}>"

  def to_owner(user, comment, reply)
    @user = user
    @comment = comment
    @reply = reply

    mail(to: @user.email,
         subject: "#{@user.default_name}さんのコメントに返信がありました！")
  end

  def to_other(user, comment, reply)
    @user = user
    @comment = comment
    @reply = reply

    mail(to: @user.email,
         subject: "#{@user.default_name}さんに関連のあるコメントに返信がありました！")
  end

  def to_other_with_comment(user, comment)
    @user = user
    @comment = comment

    mail(to: @user.email,
         subject: "#{@comment.user.default_name}さんがコメントしました！")
  end
end
