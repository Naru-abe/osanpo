Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :end_users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  # 会員側
  scope module: :public do
    get '/' => 'homes#top'
    get 'about' => 'homes#about'
    get 'search' => 'searches#search', as: 'search'
    resources :posts do
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    get 'end_users/unsubscribe' => 'end_users#unsubscribe'
    patch 'end_users/withdraw' => 'end_users#withdraw'
    resources :end_users, only: [:index, :show, :edit, :update]
  end

  # 管理者側
  namespace :admin do
    get '/' => 'homes#top'
    resources :posts, only: [:index, :show, :destroy] do
      resources :post_comments, only: [:index, :show, :destroy]
    end
    resources :tags, except: [:new, :show]
    resources :end_users, only: [:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
