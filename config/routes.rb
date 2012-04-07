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
    devise_for :users
    
    resources :users, only: [] do
      member do
        get :edit_profile
        put :update_profile
      end
    end
    
    root to: 'users#edit_profile'
  end
end
