Rails.application.routes.draw do
  resources :exchange_rates, only: :index

  root 'exchange_rates#index'
end
