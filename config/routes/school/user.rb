resources :users do
  collection do
    get :edit_profile
    patch :update_profile
    get :chart, to: 'chart#index'
  end

  get :find_by_email, on: :collection

  resources :jobs, only: [:create]

  resources :teaches, only: [:index]
end
