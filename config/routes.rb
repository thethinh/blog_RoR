Rails.application.routes.draw do
  # root routes
  root 'static_pages#home'

  # GET routes
  get  '/signup',  to: 'users#new'
  get 'static_pages/home'
  get 'static_pages/help'

  #POST routes
  post '/signup',  to: 'users#create'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
