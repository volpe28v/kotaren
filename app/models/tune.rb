class Tune < ActiveRecord::Base
  def self.all_or_filter_by_tuning(tuning)
    return self.order("tunes.id ASC") if Tuning.find_by_name(tuning) == nil
    self.includes(:tuning).where("tunings.name = ?", tuning).order("tunes.id ASC")
  end

  def self.all_or_filter_by_tuning_id(tuning_id)
    return self.order("tunes.id ASC") if Tuning.find_by_id(tuning_id) == nil
    self.includes(:tuning).where("tunings.id = ?", tuning_id).order("tunes.id ASC")
  end

  def self.get_tune_ranking
    self.all.inject([]){|touch, tune| touch << [tune, tune.progresses.active.count] }.sort{|a,b| b[1] <=> a[1]}
  end

  def self.all_play_history(user)
    touched_tunes = self.play_history.progress_by_user(user)
    untouched_tunes = self.order("id ASC") - touched_tunes
    touched_tunes + untouched_tunes
  end

  belongs_to :tuning
  has_many :recordings
  has_many :comments
  has_many :progresses

  scope :doing, lambda {
    includes(:progresses).where("progresses.percent > 0 and progresses.percent < 100").order("tunes.id ASC")
  }
  scope :done, lambda {
    includes(:progresses).where("progresses.percent = 100").order("tunes.id ASC")
  }
  scope :touched, lambda {
    includes(:progresses).where("progresses.percent > 0").order("tunes.id ASC")
  }
  scope :play_history, lambda {
    includes(:progresses).where("progresses.percent > 0").order("progresses.updated_at DESC")
  }
  scope :progress_by_user, lambda {|user|
    includes(:progresses).where("progresses.user_id = ?", user.id).order("tunes.id ASC")
  }
  scope :by_status_and_user, lambda {|status, user|
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

  def progress_val_and_updated_at(user)
    progress = self.active_progress_by_user(user)
    {
      val: progress.try!(:percent) || 0,
      updated_at: progress.try!(:updated_at ) || "-"
    }
  end

  def progress_val(user)
    progress = self.progresses.by_user(user).first
    progress.try!(:percent) || 0
  end

  def progress_updated_at(user)
    progress = self.active_progress_by_user(user)
    progress.try!(:updated_at) || "-"
  end

  def progress_created_at(user)
    progress = self.active_progress_by_user(user)
    progress.try!(:created_at) || "-"
  end

  def active_progress_by_user(user)
    self.progresses.by_user(user).active.first
  end

  def update_progress(user, val)
    raise ArgumentError if !user

    progress = self.progresses.find_or_initialize_by_user_id(user.id)
    #TODO: どんな値でも updated_at を更新したいので一旦 0 で保存している
    #      もっと良い方法があれば変更する。
    progress.percent = 0
    progress.save
    progress.percent = val
    progress.save
  end

  def touched_progresses
    #self.progresses.active.order_by_progress_degrees
    self.progresses.active.map{|pr| [pr, pr.user.comments.by_tune(self).count]}.sort{|a,b| b[1] <=> a[1] }
  end

end
