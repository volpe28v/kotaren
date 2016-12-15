class Comment < ActiveRecord::Base
  belongs_to :tune
  belongs_to :user
  has_many :replies

  validates :text, :presence => true

  scope :by_tune, lambda {|tune|
    where(:tune_id => tune.id).order("updated_at DESC")
  }

  scope :latest, lambda {
    order("updated_at DESC").limit(20)
  }

  scope :other_by, lambda {|user, limit = 20|
    where("user_id != ?", user.id).order("updated_at DESC").limit(limit)
  }
end
