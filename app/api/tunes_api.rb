module Api
  class TunesApi < Grape::API
    resource :tunes do
      get do
        Tune.all
        #パラメータも受け付ける書き方 /api/tunes?id=3
        #Tune.find(params[:id])
      end
      get ':id' do
        Tune.find(params[:id])
      end
    end
  end
end

