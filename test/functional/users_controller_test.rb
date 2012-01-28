require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
  end

  test 'should get index' do
    sign_in @user
    
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_select '#unexpected_error', false
    assert_template 'users/index'
  end

  test 'should get new' do
    sign_in @user
    
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/new'
  end

  test 'should create user' do
    sign_in @user
    
    assert_difference('User.count') do
      post :create, user: Fabricate.attributes_for(:user)
    end

    assert_redirected_to user_url(assigns(:user))
  end

  test 'should show user' do
    sign_in @user
    
    get :show, id: @user
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/show'
  end

  test 'should get edit' do
    sign_in @user
    
    get :edit, id: @user
    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'users/edit'
  end

  test 'should update user' do
    sign_in @user
    
    assert_no_difference 'User.count' do
      put :update, id: @user, user: Fabricate.attributes_for(:user, name: 'Upd')
    end
    
    assert_redirected_to user_url(assigns(:user))
    assert_equal 'Upd', @user.reload.name
  end

  test 'should destroy user' do
    sign_in @user
    
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_url
  end
  
  test 'should get edit profile' do
    sign_in @user
    
    get :edit_profile, id: @user
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @user.id, assigns(:user).id
    assert_select '#unexpected_error', false
    assert_template 'users/edit_profile'
  end
  
  test 'should update user profile' do
    sign_in @user
    
    assert_no_difference 'User.count' do
      put :update_profile, id: @user,
        user: Fabricate.attributes_for(:user, name: 'Upd')
    end
    
    assert_redirected_to edit_profile_user_url(assigns(:user))
    assert_equal 'Upd', @user.reload.name
  end
  
  test 'should not edit someone else profile' do
    another_user = Fabricate(:user)
    
    sign_in @user
    
    get :edit_profile, id: another_user
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_equal another_user.id, assigns(:user).id
    assert_equal @user.id, assigns(:user).id
    assert_select '#unexpected_error', false
    assert_template 'users/edit_profile'
  end
  
  test 'should not update someone else profile' do
    another_user = Fabricate(:user)
    
    sign_in @user
    
    assert_no_difference 'User.count' do
      put :update_profile, id: another_user,
        user: Fabricate.attributes_for(:user, name: 'Upd')
    end
    
    assert_redirected_to edit_profile_user_url(assigns(:user))
    assert_not_equal 'Upd', another_user.reload.name
    assert_equal 'Upd', @user.reload.name
  end
end
