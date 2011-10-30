class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings, :comments, :progresses

end
