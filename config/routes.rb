Rails.application.routes.draw do
  resources :productos
  resources :reviews
  resources :usuarios
  resources :suggestions
  resources :ai
  # resources :auth

  get "up" => "rails/health#show", as: :rails_health_check

  # Ruta de productos
  get 'products' => 'productos#index'
  get 'products/:id' => 'productos#show'
  post 'products' => 'productos#create'
  put 'products/:id' => 'productos#update'
  delete 'products/:id' => 'productos#destroy'

  # Rutas de AI  
  post 'ai/ask' => 'ai#ask'

  # Rutas de authenticación
  post 'auth/register' => 'auth#register'
  post 'auth/login' => 'auth#login'
end
