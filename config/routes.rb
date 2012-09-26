Libreduca::Application.routes.draw do
  constraints(AdminSubdomain) do
    resources :questions, only: [] do
      resources :replies, except: [:destroy]
    end

    resources :teaches, only: [] do
      resources :contents
    end

    resources :courses, shallow: true, only: [] do
      resources :teaches do
        post :send_email_summary, on: :member, as: 'send_email_summary'
      end
    end

    resources :grades, only: [] do
      resources :courses
    end

    resources :regions

    resources :institutions do
      resources :grades

      resources :users, only: [] do
        get :within_institution, on: :collection
      end
    end

    devise_for :users

    resources :users do
      member do
        get :edit_profile
        put :update_profile
      end
      
      resources :enrollments, only: [] do
        post :send_email_summary, on: :member, as: 'send_email_summary'
      end
    end

    match 'private/:path', to: 'files#download',
      constraints: { path: /.+/ }, via: :get

    root to: 'institutions#index'
  end
  
  constraints(SchoolSubdomain) do
    resources :images

    resources :questions, only: [] do
      resources :replies, except: [:destroy]
    end

    resources :teaches, only: [] do
      resources :contents
    end

    resources :courses, shallow: true, only: [] do
      resources :teaches do
        post :send_email_summary, on: :member, as: 'send_email_summary'
      end
    end

    resources :grades, only: [] do
      resources :courses
    end

    resources :institutions do
      resources :forums do
        member do
          get :comments
          post :comments, action: 'create_comment'
        end
      end

      resources :grades

      resources :users, only: [] do
        get :within_institution, on: :collection
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
      
      resources :enrollments, only: [] do
        post :send_email_summary, on: :member, as: 'send_email_summary'
      end
    end

    match 'private/:path', to: 'files#download',
      constraints: { path: /.+/ }, via: :get
    
    root to: 'dashboard#index'
  end
end
