Kotaren::Application.routes.draw do
  mount Api::TunesApi => '/api'

  get "albums/index"

  get "ranking/index"
  get "ranking/latest_played"

  root :to => "welcome#index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'users', :to => 'users#index', :as => :user_root

  resources :users do
    get :list , :on => :collection
    resources :tunes do
      resources :comments
      resources :progresses
      get :all , :on => :collection
      post :get_tunes_list , :on => :collection
      post :update_progress , :on => :collection
      get :load_tune_list, :on => :collection
      get :load_tune, :on => :collection
    end

    resources :albums do
      get :load_album_list, :on => :collection
    end

    resources :tunings do
      get :load_tuning_list, :on => :collection
    end
  end


  resources :comments do
    get :load_comment_list, :on => :collection
    resources :replies, :only => %w[create destroy]
  end

  resources :recordings
end
