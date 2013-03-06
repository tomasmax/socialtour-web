SocialTour::Application.routes.draw do
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
  
  #explore pois
  get '/explorer', to: 'pois#explorer', as: 'explorer'
  
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
  
  #for providers authentication
  match '/auth/:provider/callback', to: 'authentications#create'
  match '/auth/failure', to: "authentications#failure"
  match '/signout' => 'authentications#destroy'
  match '/signin' => 'authentications#new'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
