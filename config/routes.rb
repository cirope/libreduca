Edook::Application.routes.draw do
  resources :courses, only: [] do
    resources :teaches
  end

  resources :grades, only: [] do
    resources :courses
  end

  resources :regions

  resources :schools do
    resources :grades
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
