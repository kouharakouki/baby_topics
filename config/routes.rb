Rails.application.routes.draw do
  root to: 'homes#top'
  get '/about' => 'homes#about'
  devise_for :users
  devise_scope :user do
    post '/users/guest_sign_in', to: 'users#new_guest'
  end
  get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'users_unsubscribe'
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    get :followings, :followers
    resource :relationships, only: [:create, :destroy]
  end
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
end
