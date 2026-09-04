Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    delete 'users/:id', to: 'dashboard#destroy_user', as: :destroy_user
  end

  resources :categories, only: [:create, :destroy]

  resources :products do
    member do
      post :sell
    end
    resources :reviews, only: [:create, :destroy]
  end

  # RUTAS EXPLÍCITAS DEL CARRITO (Sin pedir nunca :id)
  get 'cart', to: 'carts#show', as: :cart
  post 'cart/add/:product_id', to: 'carts#add', as: :add_to_cart
  delete 'cart/remove/:item_id', to: 'carts#remove', as: :remove_cart_item
  post 'cart/checkout', to: 'carts#checkout', as: :checkout_cart

  # Catálogo y tienda pública
  get 'store', to: 'store#index', as: :store
  root "store#index"

  #historial de pedidos del comprador
  resources :orders, only: [:index, :show]
end