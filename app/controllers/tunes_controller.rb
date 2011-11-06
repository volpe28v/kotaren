class TunesController < ApplicationController
  def index
    @albums = Album.all
  end

  def show
  end

  def all
    @albums = Album.all
  end

  def get_tunes_list
    album = Album.find_by_title(params[:album_title])
    tuning = params[:tuning_name]

    if album 
      @tunes = album.tunes.all_or_filter_by_tuning(tuning)
    else
      @tunes = Tune.all_or_filter_by_tuning(tuning)
    end
  end

end

