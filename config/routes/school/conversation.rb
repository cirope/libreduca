resources :presentations, only: [] do
  resources :conversations, only: [:show, :new, :create]
end

resources :conversations, only: [] do
  resources :comments, only: [:index, :show, :new, :create]
end
