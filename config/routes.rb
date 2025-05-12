Rails.application.routes.draw do
  resources :productos
  resources :reviews
  resources :usuarios
  resources :suggestions
  resources :ai

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

  # Rutas de AI
  get 'ai' => 'suggestions#index'
  get 'ai/:id' => 'suggestions#show'
  
  post 'ai/ask' => 'ai#ask'

end
