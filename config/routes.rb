Rails.application.routes.draw do
  root to: 'homes#top'
  get '/about' => 'homes#about'
  devise_for :users
  get 'users/:id/unsubscribe' => 'users#unsubscribe', as: 'users_unsubscribe'
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
  end
end
