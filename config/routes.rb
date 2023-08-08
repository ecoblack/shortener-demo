Rails.application.routes.draw do
  post '/shorten', to: 'shortener#create'
  get '/short_urls', to: 'shortener#index'
  get '/:shortcode', to: 'shortener#show'
  # resources :short_urls, only: [:create, :index]
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
end
