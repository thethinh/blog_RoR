Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root routes
  root 'static_pages#home'

  # GET routes
  get '/signup',  to: 'users#new'
  get 'static_pages/home'
  get 'static_pages/help'
  get '/login', to: 'sessions#new'
  get 'auth/:provider/callback', to: 'sessions#getomniAuth'
  get 'auth/failure', to: redirect('/')

  # POST routes
  post '/signup',  to: 'users#create'
  post '/login', to: 'sessions#create'

  # DELETE routes
  delete '/logout', to: 'sessions#destroy'

  # Resources 
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
