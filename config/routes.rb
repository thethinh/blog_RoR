Rails.application.routes.draw do
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
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
