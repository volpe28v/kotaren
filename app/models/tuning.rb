class Tuning < ActiveRecord::Base
  has_many :tunes

  def progress_average(user)
    progress_sum_of_tunes_by_user(user) / number_of_tunes
  end

  def number_of_tunes
    self.tunes.size
  end

  def number_of_touched_tunes_by_user(user)
    progresses_of_tunes.active.by_user(user)
  end

  private
  def progress_sum_of_tunes_by_user(user)
    progresses_of_tunes.by_user(user).sum(:percent)
  end

  def progresses_of_tunes
    Progress.of_tunes(self.tunes)
  end
end
