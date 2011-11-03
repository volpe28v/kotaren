class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  def self.all_or_filter_by_tuning(tuning)
    return self.all if tuning == "-"
    self.includes(:tuning).where("tunings.name = ?", tuning ) 
  end
end
