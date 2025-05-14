Rails.application.routes.draw do
  resources :productos
  resources :reviews
  resources :usuarios
  resources :suggestions
  # resources :ai
  # resources :auth

  get "up" => "rails/health#show", as: :rails_health_check

  # Ruta de productos
  get 'products' => 'productos#index'
  post 'products' => 'productos#create'
  delete 'products/:id' => 'productos#delete'
  put 'products/:id' => 'productos#update'
  get 'products/filter' => 'productos#filter_products'

  # Rutas de AI
  post 'ai/ask' => 'ai#ask'

  # Rutas de authenticación
  post 'auth/register' => 'auth#register'
  post 'auth/login' => 'auth#login'

  # Rutas de usuarios
  get 'usuarios' => 'usuarios#index'
end
