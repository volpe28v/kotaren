class Album < ActiveRecord::Base
  has_many :recordings
end
