Rails.application.routes.draw do
  resources :styles
  resources :beerclubs
  resources :users do
    post 'change_status', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :memberships, only: [:new, :create, :destroy] do
    post 'confirm', on: :member
  end
  resource :session, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  
  resources :places, only: [:index, :show]
  post 'places', to:'places#search'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'breweries#index'
end
