Rails.application.routes.draw do
  devise_for :users

  # Panel de administración privado
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    delete 'users/:id', to: 'dashboard#destroy_user', as: 'destroy_user'
  end

  # Rutas de productos y ventas
  resources :products do
    member do
      post :sell
    end
  end

  # Ruta principal de la aplicación
  root "products#index"
end