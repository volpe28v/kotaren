class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  def self.all_or_filter_by_tuning(tuning)
    return self.all if Tuning.find_by_name(tuning) == nil
    self.includes(:tuning).where("tunings.name = ?", tuning ) 
  end

  scope :doing , includes(:progresses).where("progresses.percent > 0 and progresses.percent < 100")
  scope :done , includes(:progresses).where("progresses.percent = 100")
  scope :touched , includes(:progresses).where("progresses.percent > 0")

  scope :progress_by_user , lambda {|user|
    includes(:progresses).where("progresses.user_id = ?", user.id)
  }

  scope :by_status_and_user, lambda {|status,user|
    case status
    when "Doing"
      doing.progress_by_user(user)
    when "Done"
      done.progress_by_user(user)
    when "Touched"
      touched.progress_by_user(user)
    else

    end
  }

  def progress_val(user)
    return 0 if !user

    progress = self.progresses.find_by_user_id(user.id)

    return progress ? progress.percent : 0
  end

  def update_progress(user,val)
    return 0 if !user

    progress = self.progresses.find_by_user_id(user.id) || self.progresses.build(:user => user) 
    
    progress.percent = val
    progress.save
  end
end
