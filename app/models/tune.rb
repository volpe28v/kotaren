class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

end
