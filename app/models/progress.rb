class Progress < ActiveRecord::Base
  belongs_to :tune, :user
end
