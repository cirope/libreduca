resources :forums, only: [] do
  resources :comments, only: [:index, :create]
end
