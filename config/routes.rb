Rails.application.routes.draw do
  resources :productos
  resources :usuarios
  resources :suggestions

  get "up" => "rails/health#show", as: :rails_health_check

  # Ruta de productos
  get 'products' => 'productos#index'
  post 'products' => 'productos#create'
  delete 'products/:id' => 'productos#delete'
  put 'products/:id' => 'productos#update'
  get 'products/filter' => 'productos#filter_products'
  get 'products/:id' => 'productos#show'

  # Ruta de carrito
  get 'cart' => 'cart#index'
  post 'cart' => 'cart#create'
  delete 'cart/:id' => 'cart#delete'
  delete 'cart/remove_items' => 'cart#remove_items'

  # Rutas de AI
  post 'ai/ask' => 'ai#ask'

  # Rutas de usuarios
  get 'usuarios' => 'usuarios#index'
  post 'login' => 'usuarios#login'
  post 'register' => 'usuarios#register'
end
