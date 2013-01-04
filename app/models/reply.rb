class Reply < ActiveRecord::Base
  belongs_to :comment, :touch => true
  belongs_to :user

  validates :text, :presence => true
end
