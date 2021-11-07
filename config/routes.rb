Rails.application.routes.draw do

  scope '(:locale)', locale: /en|ja/ do
    root 'static_pages#home'

    # static_pages
    get '/guest', to:'static_pages#guest'
    get '/terms', to:'static_pages#terms'
    get '/privacy', to:'static_pages#privacy'

    # users
    get '/signup', to:'users#new'
    post '/guest', to:'users#create_guest'
    resources :users, only: [:new, :create, :edit, :update, :destroy]

    # sessions
    get     '/login', to:'sessions#new'
    post   '/login', to:'sessions#create'
    delete '/logout', to:'sessions#destroy'

    # account_activations
    resources :account_activations, only: [:edit]

    # password_resets
    resources :password_resets, only: [:new, :create, :edit, :update]

    # contacts
    resources :contacts, only: [:new, :create]

    # link_groups
    resources :link_groups, only: [:show, :create, :update, :destroy]

    # links
    resources :links, only: [:create, :update, :destroy]
    get '/search', to:'links#search'
  end
end
