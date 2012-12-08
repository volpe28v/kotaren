class Reply < ActiveRecord::Base
  belongs_to :comment, :touch => true
  belongs_to :user
end
