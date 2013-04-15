resources :questions, only: [] do
  resources :replies, except: [:destroy] do
    get :dashboard, on: :member, as: 'dashboard'
  end
end
