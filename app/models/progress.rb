class Progress < ActiveRecord::Base
  belongs_to :tune
  belongs_to :user

  scope :of_tunes, lambda {|tunes|
    where(tune_id: tunes)
  }

  scope :by_user, lambda {|user|
    where(user_id: user)
  }

  scope :active, where("percent > 0")

  scope :order_by_progress_degrees, order(:percent).reverse
end
