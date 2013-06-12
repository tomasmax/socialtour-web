SocialTour::Application.routes.draw do
  resources :lists


  devise_for :providers

  resources :comments

  resources :likes

  resources :countries

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  resources :profiles

  resources :packages

  resources :providers

  resources :ratings

  resources :supercategories

  resources :photos

  resources :pois

  resources :events

  resources :categories

  resources :authentications

  resources :users
  
  resources :friendships

  resources :cities
  
  #slug routes
  get '/pois/:slug(.:format)', to: 'pois#show', as: 'poi'
  
  #explorer
  get 'explorer/places'
  get 'explorer/events'
  
  get "pages/home"

  get "pages/contact"

  get "pages/about"
  
  root :to => 'pois#index'
  
  post '/pois/create-from-gpx', to: 'pois#create_from_gpx'

  get '/pois/:slug(.:format)', to: 'pois#show', as: 'poi'
  get '/places/:slug(.:format)', to: 'pois#show', as: 'place'
  get '/routes/:slug(.:format)', to: 'pois#show', as: 'route'
  
  match '/cities/:slug(.:format)', to: 'cities#show', as: 'city'
  
  #poi list
  match '(/:city)/:group(/:category)(.:format)', to: 'categories#show', constraints: { group: /(que-hacer|que-ver|donde-comer|donde-dormir)/ }
  
  match '/retrieval', to: 'retrieval#retrieval'
  
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',   :to => 'pages#help'
  
  match '/recommendations',   :to => 'recommendation#index'
  
  #for providers authentication
  match '/auth/:provider/callback', to: 'authentications#create'
  match '/auth/failure', to: "authentications#failure"

end
