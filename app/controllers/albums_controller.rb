class AlbumsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @albums = Album.order("id ASC")
  end

  def load_album_list
    @user = User.find(params[:user_id])
    @albums = Album.order("id ASC")

    lists = render_to_string :partial => 'album_list_body_smart_phone'
    render :json => { lists: lists },
           :callback => 'showAlbumList'
  end
end
