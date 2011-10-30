class Comment < ActiveRecord::Base
  belongs_to :tune, :user
end
