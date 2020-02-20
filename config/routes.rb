Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  # root routes
  root 'static_pages#home'

  # GET routes
  get  '/signup',  to: 'users#new'
  get 'static_pages/home'
  get 'static_pages/help'
  get '/login', to: 'sessions#new'

  # POST routes
  post '/signup',  to: 'users#create'
  post '/login', to: 'sessions#create'

  # DELETE routes
  delete '/logout', to: 'sessions#destroy'

  # Resources 
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
