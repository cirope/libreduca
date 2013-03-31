resources :news do
  resources :comments, only: [:index, :show, :new, :create]

  resources :votes, only: [:create, :destroy]
  resources :images
end
