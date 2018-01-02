Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  resources :accounts
  resources :transactions
  resources :users do
    resources :accounts, :only => [:index]
    resources :transactions, :only => [:index]
  end

end
