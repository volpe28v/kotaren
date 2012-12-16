class TunesController < ApplicationController

  @@statuses_def = [
      ['All Status', 'all_status'],
      ['Touched'   , 'touched'],
      ['Doing'     , 'doing'],
      ['Done'      , 'done'],
      ['PlayHistory','play_history'],
  ]

  def index
    @user = User.find(params[:user_id])
    if request.smart_phone?
      @tunes = Tune.all_play_history(@user)
      @other_comment = Comment.other_by(@user,30).sample
    else
      @albums = Album.scoped.order("id ASC")
      @statuses = @@statuses_def

      @current_album = selected_album_title
      @current_tuning = selected_tuning_name
      @current_status = selected_status

      @touched_count = @user.tunes_count(@@statuses_def[1][1])
      @doing_count   = @user.tunes_count(@@statuses_def[2][1])
      @done_count    = @user.tunes_count(@@statuses_def[3][1])

      @latest_comments = @user.comments.order("updated_at DESC").latest
      @other_comments = Comment.other_by(@user).order("updated_at DESC")
    end
  end

  def show
    @user = User.find(params[:user_id])
    @tune = Tune.find(params[:id])
    @progress_val = @tune.progress_val(@user)
    @comment = Comment.new
    @comments = @user.comments.by_tune(@tune)
    @other_comments = Comment.other_by(@user).by_tune(@tune)
  end

  #TODO: 未使用かも
  def all
    @albums = Album.scoped.order("id ASC")
  end

  def get_tunes_list
    @user = User.find(params[:user_id])
    album = Album.find_by_title(params[:album_title])
    tuning = params[:tuning_name]
    status = params[:tune_status]

    set_current_tune_statuses_to_session( album,tuning,status)

    base_tunes = album ? album.tunes : Tune
    @tunes = base_tunes.by_status_and_user(selected_status[1],@user).all_or_filter_by_tuning(tuning)

    set_tune_counts(@user)
  end

  def update_progress
    @user = User.find(params[:user_id])
    @tune = Tune.find(params[:tune_id])
    @tune.update_progress(@user,params[:progress_val])
    set_tune_counts(@user)

    if request.smart_phone?
      #TODO: コメントがなかった場合の処理が必要
      comment = Comment.other_by(@user).sample
      render :json => { id: @tune.id,
                        date: ApplicationController.helpers.last_played_at(@tune.progress_updated_at(@user)),
                        mini_date: ApplicationController.helpers.mini_last_played_at(@tune.progress_updated_at(@user)),
                        comment_name: comment.user.name,
                        comment_title: comment.tune.title,
                        comment_date: comment.updated_at.strftime("%y/%m/%d"),
                        comment_text: comment.text
                      },
             :callback => 'updateProgress'
    end
  end

  def load_tune_list
    @user = User.find(params[:user_id])
    @tunes = Tune.all_play_history(@user)

    lists = render_to_string :partial => 'tune_list_body_smart_phone'
    render :json => { lists: lists },
           :callback => 'showTuneList'
  end

  def load_tune
    @user = User.find(params[:user_id])
    @tune = Tune.find(params[:tune_id])

    body = render_to_string :partial => 'tune_body_smart_phone'
    render :json => { id: @tune.id,
                      user_id: @user.id,
                      tune: body },
           :callback => 'showTune'
  end

  private
  def set_current_tune_statuses_to_session( album, tuning, status )
    session[:current_album_id] = album.try(:id)
    session[:current_tuning_id] = Tuning.find_by_name(tuning).try(:id)

    status_def = @@statuses_def.detect{|sd| sd[0] == status }
    session[:current_status] = status_def ? status_def : @@statuses_def[0]
  end

  def selected_album_title
    session[:current_album_id] ? Album.find(session[:current_album_id]).title : "All Albums"
  end

  def selected_tuning_name
    session[:current_tuning_id] ? Tuning.find(session[:current_tuning_id]).name : "All Tunings"
  end

  def selected_status
    session[:current_status] ? session[:current_status] : @@statuses_def[0]
  end

  def set_tune_counts(user)
    @base_tunes = session[:current_album_id] ? Album.find(session[:current_album_id]).tunes : Tune
    tuning = session[:current_tuning_id] ? Tuning.find(session[:current_tuning_id]).name : ""

    @touched_count = @base_tunes.by_status_and_user(@@statuses_def[1][1],user).all_or_filter_by_tuning(tuning).count
    @doing_count   = @base_tunes.by_status_and_user(@@statuses_def[2][1],user).all_or_filter_by_tuning(tuning).count
    @done_count    = @base_tunes.by_status_and_user(@@statuses_def[3][1],user).all_or_filter_by_tuning(tuning).count
  end

end

