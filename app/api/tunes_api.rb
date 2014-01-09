module Api
  class TunesApi < Grape::API
    resource :tunes do
      get do
        album = Album.find_by_id(params[:album])
        base_tunes = album ? album.tunes : Tune.scoped
        base_tunes = base_tunes.all_or_filter_by_tuning_id(params[:tuning])

        base_tunes.map{|t| {:id => t.id, :title => t.title,:tuning_id => t.tuning_id}}
      end

      get ':id' do
        Tune.find(params[:id])
      end
    end
  end
end

