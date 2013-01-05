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

    root to: redirect('/users/sign_in')
  end

  constraints(SchoolSubdomain) do
    match '/launchpad' => 'launchpad#index', as: 'launchpad', via: :get

    resources :images

    resources :questions, only: [] do
      resources :replies, except: [:destroy]
    end

    resources :teaches, only: [] do
      resources :contents
      resources :surveys

      resources :forums do
        member do
          get :comments
          post :comments, action: 'create_comment'
        end
      end
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
          get :edit_scores, as: 'edit_scores'
          get :edit_enrollments, as: 'edit_enrollments'
          post :send_email_summary, as: 'send_email_summary'
        end
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
      resources :users
    end

    match '/dashboard(.:format)' => 'dashboard#index', as: 'dashboard', via: :get

    Job::TYPES.each do |job_type|
      match "/dashboard/#{job_type}(.:format)" => "dashboard##{job_type}",
        as: "#{job_type}_dashboard", via: :get
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

      resources :teaches, only: [:index]
    end

    match 'private/:path', to: 'files#download',
      constraints: { path: /.+/ }, via: :get

    resources :pages, only: [:show] do
      resources :blocks
      post :sort, controller: :blocks
    end

    root to: "pages#show"
  end

  get 'errors/error_404'

  match '*not_found', to: 'errors#error_404'
end
