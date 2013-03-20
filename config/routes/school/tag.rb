resources :tags, only: [:index] do
  resources :news, only: [:index]
end
