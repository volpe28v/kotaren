class TunesController < ApplicationController
  def index
    @albums = Album.all
  end

  def show
  end

end
