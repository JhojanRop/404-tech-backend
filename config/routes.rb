Rails.application.routes.draw do
  resources :productos
  resources :reviews
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Ruta de productos
  get 'products' => 'productos#index'
  get 'products/:id' => 'productos#show'
  post 'products' => 'productos#create'
  put 'products/:id' => 'productos#update'
  delete 'products/:id' => 'productos#destroy'

  # Rutas de usuarios
  get 'users' => 'usuarios#index'
  get 'users/:id' => 'usuarios#show'
  post 'users' => 'usuarios#create'
  put 'users/:id' => 'usuarios#update'
  delete 'users/:id' => 'usuarios#destroy'

  post 'login' => 'usuarios#login'

  # Defines the root path route ("/")
  # root "posts#index"
end
