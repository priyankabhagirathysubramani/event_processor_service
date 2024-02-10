Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post '/webhooks/stripe', to: 'webhooks#stripe'
  
  # resources :webhooks, only: [] do
  #   collection do
  #     post :stripe
  #   end
  # end
end
