resources :teaches, only: [] do
  resources :forums
  resources :contents
  resources :surveys
end
