Kotaren::Application.routes.draw do

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
      get :update_progress , :on => :collection
    end
  end

  resources :tunings, :albums, :recordings
end
