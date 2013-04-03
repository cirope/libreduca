resources :contents, only: [] do
  resources :surveys

  resources :homeworks, only: [] do
    resources :presentations, except: [:edit, :update]
  end
end
