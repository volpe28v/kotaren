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

    resource :activities do
      get do
        user = User.find_by_id(params[:user_id])
        from = params[:start]
        to = params[:stop]

        comments = user.comments.where(created_at: from..to)
        comments_count = comments.map{|c| c.created_at.to_i}.inject(Hash.new(0)){|h, tm| h[tm] += 1; h}

        activities = user.activities.where(date: from.to_date..to.to_date)
        act_count = activities.inject(Hash.new(0)){|h, act| h[act.date.to_time.to_datetime.to_i] = act.count; h}

        act_count.merge(comments_count){ |key, self_val, other_val|
          self_val + other_val
        }.to_json
      end
    end
  end
end

