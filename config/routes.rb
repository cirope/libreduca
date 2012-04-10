Libreduca::Application.routes.draw do
  constraints(AdminSubdomain) do
    resources :courses, only: [] do
      resources :teaches
    end

    resources :grades, only: [] do
      resources :courses
    end

    resources :regions

    resources :schools do
      resources :grades

      resources :users, only: [] do
        get :within_school, on: :collection
      end
    end

    devise_for :users

    resources :users do
      member do
        get :edit_profile
        put :update_profile
      end
    end

    root to: 'schools#index'
  end
  
  constraints(SchoolSubdomain) do
    resources :courses, only: [] do
      resources :teaches
    end

    resources :grades, only: [] do
      resources :courses
    end

    resources :schools do
      resources :grades

      resources :users, only: [] do
        get :within_school, on: :collection
      end
    end
    
    match '/dashboard(.:format)' => 'dashboard#index', as: 'dashboard', via: :get
    
    Job::TYPES.each do |job_type|
      match "/dashboard/#{job_type}(.:format)" => "dashboard##{job_type}",
        as: "#{job_type}_dashboard", via: :get
    end
    
    devise_for :users
    
    resources :users, only: [] do
      member do
        get :edit_profile
        put :update_profile
      end
    end
    
    root to: 'dashboard#index'
  end
end
