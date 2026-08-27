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
  end

  root "products#index"
end