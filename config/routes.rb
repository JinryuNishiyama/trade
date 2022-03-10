Rails.application.routes.draw do
  root 'games#index'

  resources :games do
    collection do
      get 'list'
      get 'search'
    end
    resources :posts, only: :create do
      resource :likes, only: [:create, :destroy]
    end
  end

  devise_for :users, skip: [:passwords]
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users, only: :show

  namespace :admin do
    resources :users
    resources :games
    resources :posts
    resources :likes

    root 'users#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
