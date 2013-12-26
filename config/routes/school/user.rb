resources :users do
  collection do
    get :edit_profile
    patch :update_profile
    get :find_by_email
  end

  get :chart, to: 'chart#index', on: :member

  resources :jobs, only: [:create]

  resources :teaches, only: [:index]
end
