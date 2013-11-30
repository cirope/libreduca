resources :users do
  member do
    get :edit_profile
    put :update_profile
    get :chart, to: 'chart#index'
  end

  get :find_by_email, on: :collection
  resources :jobs, only: [:create]

  resources :teaches, only: [:index]
end
