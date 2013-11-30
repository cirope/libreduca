resources :users do
  member do
    get :edit_profile
    put :update_profile
  end
end
