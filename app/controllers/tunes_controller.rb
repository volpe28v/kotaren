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
    status = params[:tune_status]

    @tunes = album ? album.tunes : Tune
    @tunes = @tunes.by_status_and_user(status,current_user).all_or_filter_by_tuning(tuning)
  end

  def update_progress
    tune = Tune.find(params[:tune_id])
    tune.update_progress(current_user,params[:progress_val])
    render :text => "update_progress .. OK!"
  end
end

