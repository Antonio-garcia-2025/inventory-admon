Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  resources :products do
    member do
      post :sell
    end
  end

  root "products#index"