resources :users, only: [] do
  resources :enrollments, only: [] do
    post :send_email_summary, on: :member, as: 'send_email_summary'
  end
end
