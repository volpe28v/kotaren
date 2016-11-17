module Api
  class TunesApi < Grape::API
    resource :tunes do
      get do
        user_id = params[:user_id]
        touched_tunes = Tune.includes({recordings: :album}, :progresses, :tuning).where(progresses: {user_id: user_id})
        untouched_tunes = Tune.includes({recordings: :album}, :tuning).order("id ASC") - touched_tunes
        all_tunes = touched_tunes + untouched_tunes

        touched_tunes = touched_tunes.map{|tune|
          {
            tune: tune,
            albums: tune.recordings.map{|rec| rec.album},
            progress: tune.progresses.first,
            tuning: tune.tuning
          }
        }

        untouched_tunes = untouched_tunes.map{|tune|
          {
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

    resource :comments do
      get do
        comments = nil

        tune_id = params[:tune_id]
        user_id = params[:user_id]

        if tune_id != nil && user_id != nil
          tune = Tune.find(params[:tune_id])
          user_id = params[:user_id]

          comments = tune.comments.includes({replies: :user}, :tune, :user).where(user_id: user_id).order("updated_at desc")
        else
          comments = Comment.includes({replies: :user}, :tune, :user).scoped.order("updated_at DESC").limit(50)
        end

        comments.map{|comment|
          {
            comment: comment,
            tune: comment.tune,
            user: {
              id: comment.user.id,
              name: comment.user.name,
              icon_url: comment.user.icon_url
            },
            replies: comment.replies.order("updated_at desc").map{|reply|
              {
                id: reply.id,
                text: reply.text,
                updated_at: reply.updated_at,
                #user: reply.user
                user: {
                  id: reply.user ? reply.user.id: 0,
                  name: reply.user ? reply.user.name : 'unknown',
                  icon_url: reply.user ? reply.user.icon_url: '',
                }
              }
            }
          }
        }
      end

      get ':id' do
        comment_id = params[:id]
        comment = Comment.includes({replies: :user}, :tune, :user).find(comment_id)

        {
          comment: comment,
          tune: comment.tune,
          user: comment.user,
          replies: comment.replies.order("updated_at desc").map{|reply|
            {
              id: reply.id,
              text: reply.text,
              updated_at: reply.updated_at,
              user: reply.user
            }
          }
        }
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

    resource :activity_counts do
      get do
        user = User.find_by_id(params[:user_id])
        to = DateTime.now
        from = to.ago(1.years)

        activities = user.activities.where(date: from.to_date..to.to_date)
        act_count = activities.inject(Hash.new(0)){|h, act| h[act.date.to_time.to_datetime.to_i] = act.count; h}

        {
          count: act_count.size
        }
      end
    end

  end
end

