Rails.application.routes.draw do
  resources :styles
  resources :beerclubs
  resources :users do
    post 'change_status', on: :member
    get 'recommendation', on: :member
    get 'hotwire', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
    get 'hotwire', on: :collection
    get 'active', on: :collection
    get 'retired', on: :collection
  end
  resources :ratings, only: [:index, :new, :create, :destroy, :show] do
    get 'best_beers', on: :collection
    get 'best_breweries', on: :collection
    get 'best_styles', on: :collection
    get 'most_active_users', on: :collection
  end
  resources :memberships, only: [:new, :create, :destroy] do
    post 'confirm', on: :member
  end
  resource :session, only: [:new, :create, :destroy]
  resources :messages, only: [:index, :new, :create]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  
  resources :places, only: [:index, :show]
  post 'places', to:'places#search'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
  delete 'ratings', to: 'ratings#remove'
  get 'calculator', to: 'misc#calculator'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'breweries#index'
end
