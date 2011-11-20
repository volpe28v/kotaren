class TunesController < ApplicationController
  before_filter :authenticate_user! 

  @@statuses_def = [
      ['All Status', 'all_status'],
      ['Touched'   , 'touched'],
      ['Doing'     , 'doing'],
      ['Done'      , 'done'],
  ]

  def index
    @albums = Album.all
    @statuses = @@statuses_def
    @current_status = session[:current_status] ? session[:current_status] : @statuses[0]
  end

  def show
    @tune = Tune.find(params[:id])
  end

  def all
    @albums = Album.all
  end

  def get_tunes_list
    album = Album.find_by_title(params[:album_title])
    tuning = params[:tuning_name]
    status = params[:tune_status]

    session[:current_status] = @@statuses_def.detect{|sd| sd[0] == status }

    @tunes = album ? album.tunes : Tune
    @tunes = @tunes.by_status_and_user(status,current_user).all_or_filter_by_tuning(tuning)
  end

  def update_progress
    tune = Tune.find(params[:tune_id])
    tune.update_progress(current_user,params[:progress_val])
    render :text => "update_progress .. OK!"
  end
end

