Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :accounts
  resources :transactions
  resources :users do
    resources :accounts, :only => [:index]
    resources :transactions, :only => [:index]
  end

end
