require "sidekiq/web"
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  post 'signup', to: 'authentication#signup'
  post 'login', to: 'authentication#login'
  put    'users/:id',   to: 'authentication#update'
  # delete 'users/:id',   to: 'authentication#destroy'
    resources :plogs, only: [:index, :show, :create, :update, :destroy] do
    resources :faqs, only: [:index, :create, :update, :destroy]
    resources :contents, only: [:index, :create, :update, :destroy]
  end
  get "up" => "rails/health#show", as: :rails_health_check
  get "plogs_landing", to: "web_site#plogs_landing"
  get "plog_show/", to: "web_site#plog_show"
  post '/faqs', to: 'faqs#create_without_plog'
  get '/faq_about_us', to: 'web_site#faq_about_us'
  put '/faqs/:id', to: 'faqs#update_without_plog'
  delete '/faqs/:id', to: 'faqs#delete_without_plog'
  mount Sidekiq::Web => "/sidekiq"

  # Defines the root path route ("/")
  # root "posts#index"
end
