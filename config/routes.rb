X0Y0::Application.routes.draw do
  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
