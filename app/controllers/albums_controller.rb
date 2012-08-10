class AlbumsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @albums = Album.all
  end
end
