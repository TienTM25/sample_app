Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/help", to: "static_page#help"
    get "/about", to: "static_page#about"
    get "/contact", to: "static_page#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users do
      member do
        get "/following", to: "following#index", as: "following"
        get "/followers", to: "followers#index", as: "followers"
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
