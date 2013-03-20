resources :courses, shallow: true, only: [] do
  resources :teaches do
    member do
      get :show_scores, as: 'show_scores'
      get :show_enrollments, as: 'show_enrollments'
      get :show_tracking, as: 'show_tracking'
      get :edit_scores, as: 'edit_scores'
      get :edit_enrollments, as: 'edit_enrollments'
      post :send_email_summary, as: 'send_email_summary'
    end
  end
end
