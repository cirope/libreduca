resources :contents, only: [] do
  resources :surveys
  resources :presentations, only: [:index]

  resources :homeworks, only: [] do
    resources :presentations, except: [:edit, :update]
  end
end
