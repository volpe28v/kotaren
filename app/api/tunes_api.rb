module Api
  class TunesApi < Grape::API
    resource :tunes do
      get do
        #TODO user_id を設定する
        touched_tunes = Tune.includes({recordings: :album}, :progresses, :tuning).where(progresses: {user_id: 2})
        untouched_tunes = Tune.includes({recordings: :album}, :tuning).order("id ASC") - touched_tunes
        all_tunes = touched_tunes + untouched_tunes

        touched_tunes = touched_tunes.map{|tune|
          th = {
            tune: tune,
            albums: tune.recordings.map{|rec| rec.album},
            progress: tune.progresses.first,
            tuning: tune.tuning
          }
        }

        untouched_tunes = untouched_tunes.map{|tune|
          th = {
            tune: tune,
            albums: tune.recordings.map{|rec| rec.album},
            progress: { percent: 0 },
            tuning: tune.tuning
          }
        }

        touched_tunes + untouched_tunes
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

