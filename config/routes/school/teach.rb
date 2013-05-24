resources :teaches, only: [] do
  resources :forums
  resources :contents
  resources :surveys, only: [:index, :show, :edit]
end
