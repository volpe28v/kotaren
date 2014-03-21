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

    resource :comments do
      get do
        user = User.find_by_id(params[:user_id])
        from = params[:start]
        to = params[:stop]

        comments = user.comments.where(created_at: from...to)
        comments.map{|c| c.created_at.to_i}.inject(Hash.new(0)){|h, tm| h[tm] += 1; h}.to_json
      end
    end
  end
end

