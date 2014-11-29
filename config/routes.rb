BookXchange::Application.routes.draw do  
  
  # get "admin/index"
  root 'home#index'
  get 'about', to: 'home#about'
  resources :accounts
  resources :books

  get '/signup', to: 'accounts#new'

  resources :sessions, only: [:new, :create, :destroy]
  match '/signin', to: 'sessions#new', via: :get
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/search', to: 'books#search', via: :post

  get 'books/:id/buy' => 'books#buy', as: :buy_book
  match 'books/:id/buy' => 'books#buy', via: :post
  get 'books/:id/get' => 'books#get_book', as: :get_book

  match '/admin', to: 'admin#index', via: :get
  get '/make_admin/:id' => 'admin#make_admin', as: :make_admin
  get '/revoke_admin/:id' => 'admin#revoke_admin', as: :revoke_admin
  get 'admin/credit/:id' => 'admin#credit', as: :credit
  get 'admin/create_profile/:id' => 'admin#create_profile', as: :create_profile
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
