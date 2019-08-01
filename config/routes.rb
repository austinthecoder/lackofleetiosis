Rails.application.routes.draw do

  root to: 'application#root'

  resources :vehicles, only: [:create, :index, :show]

  match '', to: 'application#not_found', via: :all
  match '*path', to: 'application#not_found', via: :all

end
