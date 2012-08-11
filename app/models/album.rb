class Album < ActiveRecord::Base
  has_many :recordings
  has_many :tunes , :through => :recordings

  def progress_average(user)
    progress_sum = self.tunes.inject(0){|sum,t|
      sum += t.progress_val(user)
    }

    return progress_sum / self.tunes.size
  end
end
