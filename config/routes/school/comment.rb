resources :comments, only: [] do
  resources :votes, only: [:create, :destroy]
end
