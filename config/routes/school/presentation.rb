resources :presentations, only: [] do
  resources :comments, only: [:index, :create]
end
