class Comment < ActiveRecord::Base
  belongs_to :tune
  belongs_to :user
end
