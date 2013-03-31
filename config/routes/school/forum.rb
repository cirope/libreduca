resources :forums, only: [] do
  resources :comments, only: [:index, :show, :new, :create]
end
