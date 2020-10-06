# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root routes
  root 'static_pages#home'

  # GET routes
  get '/signup', to: 'users#new'
  get 'static_pages/home'
  get 'static_pages/help'
  get '/login', to: 'sessions#new'
  get 'auth/:provider/callback', to: 'sessions#access_auth'
  get 'auth/failure', to: redirect('/')
  get '/download/infor_csv', to: 'downloadcsvs#info_csv'
  get '/reaction_comment', to: 'reactions#reaction_comment'
  get '/reaction_micropost', to: 'reactions#reaction_micropost'
  get '/show_subcomment', to: 'comments#show_subcomment'
  get '/static_pages/error_page', to: 'static_pages#error_page'

  # POST routes
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  post '/create_subcmt', to: 'comments#create_subcmt'

  # DELETE routes
  delete '/logout', to: 'sessions#destroy'

  # Resources
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
  resources :microposts,          only: %i[create destroy]
  resources :relationships,       only: %i[create destroy]
  resources :comments, only: %i[create destroy edit]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts do
    resources :comments, only: [:index]
  end

  resources :users do
    resources :comments, only: [:update]
  end

  resources :conversations, only: [:create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

  # Action cable
  mount ActionCable.server, at: '/cable'
end
