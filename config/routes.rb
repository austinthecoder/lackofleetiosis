Rails.application.routes.draw do

  root to: 'application#root'

  match '', to: 'application#not_found', via: :all
  match '*path', to: 'application#not_found', via: :all

end
