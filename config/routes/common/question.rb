resources :questions, only: [] do
  resources :replies, except: [:destroy]
end
