class Album < ActiveRecord::Base
  has_many :recordings
  has_many :tunes , :through => :recordings

  def progress_average(user)
    progress_sum_of_tunes_by_user(user) / number_of_tunes
  end

  private
  def number_of_tunes
    self.tunes.size
  end

  def progress_sum_of_tunes_by_user(user)
    progresses_of_tunes.by_user(user).sum(:percent)
  end

  def progresses_of_tunes
    Progress.of_tunes(self.tunes)
  end
end
