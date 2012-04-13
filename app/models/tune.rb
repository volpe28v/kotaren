class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  def self.all_or_filter_by_tuning(tuning)
    return self.order("tunes.id ASC") if Tuning.find_by_name(tuning) == nil
    self.includes(:tuning).where("tunings.name = ?", tuning ).order("tunes.id ASC")
  end

  scope :doing , includes(:progresses).where("progresses.percent > 0 and progresses.percent < 100").order("tunes.id ASC")
  scope :done , includes(:progresses).where("progresses.percent = 100").order("tunes.id ASC")
  scope :touched , includes(:progresses).where("progresses.percent > 0").order("tunes.id ASC")

  scope :progress_by_user , lambda {|user|
    includes(:progresses).where("progresses.user_id = ?", user.id).order("tunes.id ASC")
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

  def progress_updated_at(user)
    return '-' if !user
    return '-' if self.progress_val(user) == 0

    progress = self.progresses.find_by_user_id(user.id)
    return progress ? progress.updated_at : "-"
  end

  def update_progress(user,val)
    return 0 if !user

    progress = self.progresses.find_or_initialize_by_user_id(user.id)
    progress.percent = val
    progress.save
  end

  def touched_progresses
    self.progresses.where("percent > 0").sort{|a,b| b.percent <=> a.percent }
  end

  def self.get_tune_ranking
    self.all.inject([]){|touch,tune| touch << [tune, tune.progresses.where("percent > 0").count] }.sort{|a,b| b[1] <=> a[1]}
  end

end
