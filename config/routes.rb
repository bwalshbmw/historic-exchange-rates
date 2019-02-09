Rails.application.routes.draw do
  resources :exchange_rates, only: :index

  namespace :charts do
    get 'historic-rates'
  end

  root 'exchange_rates#index'
end
