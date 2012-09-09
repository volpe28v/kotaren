class Tune < ActiveRecord::Base
  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  def self.all_or_filter_by_tuning(tuning)
    return self.order("tunes.id ASC") if Tuning.find_by_name(tuning) == nil
    self.includes(:tuning).where("tunings.name = ?", tuning ).order("tunes.id ASC")
  end

  def self.get_tune_ranking
    self.all.inject([]){|touch, tune| touch << [tune, tune.progresses.active.count] }.sort{|a,b| b[1] <=> a[1]}
  end

  scope :doing , includes(:progresses).where("progresses.percent > 0 and progresses.percent < 100").order("tunes.id ASC")
  scope :done , includes(:progresses).where("progresses.percent = 100").order("tunes.id ASC")
  scope :touched , includes(:progresses).where("progresses.percent > 0").order("tunes.id ASC")
  scope :play_history , includes(:progresses).where("progresses.percent > 0").order("progresses.updated_at DESC")

  scope :progress_by_user , lambda {|user|
    includes(:progresses).where("progresses.user_id = ?", user.id).order("tunes.id ASC")
  }

  scope :by_status_and_user, lambda {|status,user|
    case status
    when "doing"
      doing.progress_by_user(user)
    when "done"
      done.progress_by_user(user)
    when "touched"
      touched.progress_by_user(user)
    when "play_history"
      play_history.progress_by_user(user)
    end
  }

  def progress_val(user)
    return 0 if !user

    progress = self.progresses.by_user(user).first
    return progress ? progress.percent : 0
  end

  def progress_updated_at(user)
    return '-' if !user
    return '-' if self.progress_val(user) == 0

    progress = self.progresses.by_user(user).first
    return progress ? progress.updated_at : "-"
  end

  def update_progress(user, val)
    return 0 if !user

    progress = self.progresses.find_or_initialize_by_user_id(user.id)
    #TODO: どんな値でも updated_at を更新したいので一旦 0 で保存している
    #      もっと良い方法があれば変更する。
    progress.percent = 0
    progress.save
    progress.percent = val
    progress.save
  end

  def touched_progresses
    self.progresses.active.order_by_progress_degrees
  end

end
