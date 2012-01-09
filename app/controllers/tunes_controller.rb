class TunesController < ApplicationController
  before_filter :authenticate_user! 

  @@statuses_def = [
      ['All Status', 'all_status'],
      ['Touched'   , 'touched'],
      ['Doing'     , 'doing'],
      ['Done'      , 'done'],
  ]

  def index
    @user = User.find(params[:user_id])
    @albums = Album.all
    @statuses = @@statuses_def

    @current_album = selected_album_title
    @current_tuning = selected_tuning_name
    @current_status = selected_status

    @touched_count = @user.tunes_count(@@statuses_def[1][0])
    @doing_count   = @user.tunes_count(@@statuses_def[2][0])
    @done_count    = @user.tunes_count(@@statuses_def[3][0])

    @latest_comments = @user.comments.latest
    @other_comments = Comment.other_by(@user)
  end

  def show
    @user = User.find(params[:user_id])
    @tune = Tune.find(params[:id])
    @progress_val = @tune.progress_val(@user)
    @comment = Comment.new
    @comments = @user.comments.by_tune(@tune)
    @other_comments = Comment.other_by(@user).by_tune(@tune)
    @other_member_count = Progress.includes(:tune).where("tunes.id = ? and percent > 0", @tune.id).count - ( @progress_val > 0 ? 1 : 0 )
  end

  def all
    @albums = Album.all
  end

  def get_tunes_list
    @user = User.find(params[:user_id])
    album = Album.find_by_title(params[:album_title])
    tuning = params[:tuning_name]
    status = params[:tune_status]

    session[:current_album_id] = album.try(:id)
    session[:current_tuning_id] = Tuning.find_by_name(tuning).try(:id)
    session[:current_status] = @@statuses_def.detect{|sd| sd[0] == status }

    base_tunes = album ? album.tunes : Tune
    @tunes = base_tunes.by_status_and_user(status,@user).all_or_filter_by_tuning(tuning)

    set_tune_counts(@user)
  end

  def update_progress
    @user = User.find(params[:user_id])
    tune = Tune.find(params[:tune_id])
    tune.update_progress(@user,params[:progress_val])

    set_tune_counts(@user)
  end

  private
  def selected_album_title
    session[:current_album_id] ? Album.find(session[:current_album_id]).title : "All Albums"
  end

  def selected_tuning_name
    session[:current_tuning_id] ? Tuning.find(session[:current_tuning_id]).name : "All Tunings"
  end

  def selected_status
    session[:current_status] ? session[:current_status] : @statuses[0]
  end

  def set_tune_counts(user)
    @base_tunes = session[:current_album_id] ? Album.find(session[:current_album_id]).tunes : Tune
    tuning = session[:current_tuning_id] ? Tuning.find(session[:current_tuning_id]).name : "" 

    @touched_count = @base_tunes.by_status_and_user(@@statuses_def[1][0],user).all_or_filter_by_tuning(tuning).count
    @doing_count   = @base_tunes.by_status_and_user(@@statuses_def[2][0],user).all_or_filter_by_tuning(tuning).count
    @done_count    = @base_tunes.by_status_and_user(@@statuses_def[3][0],user).all_or_filter_by_tuning(tuning).count
  end

end

