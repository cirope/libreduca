resources :surveys, only: [] do
  resources :replies, only: [:index] do
    get '/dashboard', to: 'replies#dashboard', as: 'dashboard', on: :collection
  end

  resources :users, only: [] do
    resources :replies, only: [:index]
  end
end
