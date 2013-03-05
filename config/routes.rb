Libreduca::Application.routes.draw do
  constraints(AdminSubdomain) do
    match '/launchpad' => 'launchpad#index', as: 'launchpad', via: :get

    resources :questions, only: [] do
      resources :replies, except: [:destroy]
    end

    resources :teaches, only: [] do
      resources :contents
      resources :surveys
    end

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

    resources :grades, only: [] do
      resources :courses
    end

    resources :regions

    resources :institutions do
      resources :grades
      resources :users
    end

    devise_for :users, controllers: { passwords: 'passwords' }

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

    root to: redirect('/users/sign_in')
  end

  constraints(SchoolSubdomain) do
    get '/launchpad' => 'launchpad#index', as: 'launchpad'

    get '/chart' => 'chart#index', as: 'chart'

    resources :images

    resources :questions, only: [] do
      resources :replies, except: [:destroy]
    end

    resources :teaches, only: [] do
      resources :forums
      resources :contents
      resources :surveys
    end

    resources :contents, only: [] do
      resources :homeworks, only: [] do
        resources :presentations, except: [:edit, :update]
      end
    end

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

    resources :grades, only: [] do
      resources :courses
    end

    resources :forums, only: [] do
      resources :comments, only: [:index, :show, :new, :create]
    end

    resources :news do
      resources :comments, only: [:index, :show, :new, :create]

      resources :votes, only: [:create, :destroy]
      resources :images
    end

    resources :comments, only: [] do
      resources :votes, only: [:create, :destroy]
    end

    resources :institutions do
      resources :grades
      resources :users
      resources :forums
    end

    resources :groups

    resources :tags, only: [:index] do
      resources :news, only: [:index]
    end

    match '/dashboard(.:format)' => 'dashboard#index', as: 'dashboard', via: :get

    Job::TYPES.each do |job_type|
      match "/dashboard/#{job_type}(.:format)" => "dashboard##{job_type}",
        as: "#{job_type}_dashboard", via: :get
    end

    devise_for :users, controllers: { passwords: 'passwords' }

    resources :users do
      member do
        get :edit_profile
        put :update_profile
        get :chart, to: 'chart#index'
      end

      get :find_by_email, on: :collection
      resources :jobs, only: [:create]

      resources :enrollments, only: [] do
        post :send_email_summary, on: :member, as: 'send_email_summary'
      end

      resources :teaches, only: [:index]
    end

    match 'private/:path', to: 'files#download',
      constraints: { path: /.+/ }, via: :get

    root to: redirect('/users/sign_in')
  end

  get 'errors/error_404'

  match '*not_found', to: 'errors#error_404'
end
