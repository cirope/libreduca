resources :news do
  resources :comments, only: [:index, :create]

  resources :votes, only: [:create, :destroy]
  resources :images
end
