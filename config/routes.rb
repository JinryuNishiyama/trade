Rails.application.routes.draw do
  root 'games#index'

  get 'games/list'
  resources :games do
    resources :posts, only: :create
  end

  devise_for :users, skip: [:passwords]
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
