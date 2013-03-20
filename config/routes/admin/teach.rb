resources :teaches, only: [] do
  resources :contents
  resources :surveys
end
