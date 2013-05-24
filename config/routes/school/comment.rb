resources :comments, only: [] do
  resources :votes, only: [:create, :destroy]
end

resources :presentations, only: [] do
  resources :comments, only: [:index, :create]
end

resources :replies, only: [] do
  resources :comments, only: [:index, :create]
end
