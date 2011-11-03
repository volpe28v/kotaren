class Album < ActiveRecord::Base
  has_many :recordings
  has_many :tunes , :through => :recordings
end
