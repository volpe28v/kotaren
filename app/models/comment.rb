class Comment < ActiveRecord::Base
  belongs_to :tune
  belongs_to :user

  scope :by_tune, lambda {|tune|
    where(:tune_id => tune.id).order("updated_at DESC")
  }

  scope :latest, order("updated_at DESC").limit(20)

  scope :other_by, lambda {|user|
    where("user_id != ?", user.id).order("updated_at DESC").limit(20)
  }
end
