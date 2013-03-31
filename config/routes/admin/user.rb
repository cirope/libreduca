resources :users do
  member do
    get :edit_profile
    put :update_profile
  end

  resources :enrollments, only: [] do
    post :send_email_summary, on: :member, as: 'send_email_summary'
  end
end
