resources :users do
  member do
    get :edit_profile
    patch :update_profile
  end
end
