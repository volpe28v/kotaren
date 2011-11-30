class Comment < ActiveRecord::Base
  belongs_to :tune
  belongs_to :user

  scope:my_memo, lambda {|user,tune|
    includes(:tune).includes(:user).where("tunes.id = ? and users.id = ?",tune.id,user.id)
  }
end
