Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/help", to: "static_page#help"
    get "/about", to: "static_page#about"
    get "/contact", to: "static_page#contact"
    get "/signup", to: "user#new"
  end
end
