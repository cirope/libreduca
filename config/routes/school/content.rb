resources :contents, only: [] do
  resources :homeworks, only: [] do
    resources :presentations, except: [:edit, :update]
  end
end
