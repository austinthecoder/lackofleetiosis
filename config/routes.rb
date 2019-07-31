Rails.application.routes.draw do
  match '*path', to: 'application#not_found', via: :all
end
