class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  def self.all_or_filter_by_tuning(tuning)
    return self.all if Tuning.find_by_name(tuning) == nil
    self.includes(:tuning).where("tunings.name = ?", tuning ) 
  end

  def progress_val(user)
    return 0 if !user

    progress = self.progresses.find_by_user_id(user.id)

    return progress ? progress.percent : 0
  end

  def update_progress(user,val)
    return 0 if !user

    progress = self.progresses.find_by_user_id(user.id)
    unless progress
      progress = self.progresses.build
      user.progresses << progress
    end
    progress.percent = val
    progress.save
  end
end
