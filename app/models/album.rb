class Album < ActiveRecord::Base
  has_many :recordings
  has_many :tunes, :through => :recordings

  def progress_average(user)
    progress_sum_of_tunes_by_user(user) / number_of_tunes
  end

  def thumbnail_url
    ApplicationController.helpers.image_path("albums/#{title}.jpg")
  end

  def mini_thumbnail_url
    ApplicationController.helpers.image_path("albums/mini/#{title}_s.jpg")
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
