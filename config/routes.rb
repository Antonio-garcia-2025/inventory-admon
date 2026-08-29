Rails.application.routes.draw do
  devise_for :users

  # Panel de Administración
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    delete 'users/:id', to: 'dashboard#destroy_user', as: :destroy_user
  end

  # Gestión de Categorías
  resources :categories, only: [:create, :destroy]

  # Inventario del Vendedor
  resources :products do
    member do
      post :sell
    end
  end

  # Tienda Pública / Marketplace
  get 'store', to: 'store#index', as: :store
  post 'store/buy/:id', to: 'store#buy', as: :store_buy

  # La página principal ahora es la Tienda Pública
  root "store#index"
end