Rails.application.routes.draw do

  resources :vehicles, only: [:create, :index, :show] do
    member { post :reprocess }
  end

  match '', to: 'application#not_found', via: :all
  match '*path', to: 'application#not_found', via: :all

end
