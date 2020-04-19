Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: 'pages#home'

  resources :islands, only: [ :index, :show ]

  resources :producers

end