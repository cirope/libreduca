Edook::Application.routes.draw do
  resources :schools

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: 'schools#index'
end
