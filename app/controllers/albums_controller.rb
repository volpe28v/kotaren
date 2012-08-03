class AlbumsController < ApplicationController
  def index
    @albums = Album.all
  end

end
