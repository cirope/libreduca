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

  test 'should get filtered index' do
    sign_in @user

    3.times { Fabricate(:user, lastname: 'in_filtered_index') }

    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:users)
    assert_equal 3, assigns(:users).size
    assert assigns(:users).all? { |u| u.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:users).size, User.count
    assert_select '#unexpected_error', false
    assert_template 'users/index'
  end

  test 'should get filtered index in json' do
    sign_in @user

    3.times { Fabricate(:user, name: 'in_filtered_index') }

    get :index, q: 'filtered_index', format: 'json'
    assert_response :success

    users = ActiveSupport::JSON.decode(@response.body)

    assert_equal 3, users.size
    assert users.all? { |u| u['label'].match /filtered_index/i }

    get :index, q: 'no_user', format: 'json'
    assert_response :success

    users = ActiveSupport::JSON.decode(@response.body)

    assert_equal 0, users.size
  end

  test 'should get institution index' do
    institution = login_into_institution

    3.times do
      Fabricate(:user).tap do |user|
        Fabricate(:job, user_id: user.id, institution_id: institution.id)
      end
    end

    Fabricate(:user) # Without job in institution

    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_equal 4, assigns(:users).size # 3 + 1 in logged in
    assert assigns(:users).all? { |u| u.institutions.include?(institution) }
    assert_select '#unexpected_error', false
    assert_template 'users/index'
  end

  test 'should get institution filtered index' do
    institution = login_into_institution

    Fabricate(:user, lastname: 'in_filtered_index') # No match, outside institution

    3.times do
      Fabricate(:user, lastname: 'in_filtered_index').tap do |user|
        Fabricate(:job, user_id: user.id, institution_id: institution.id)
      end
    end

    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:users)
    assert_equal 3, assigns(:users).size
    assert assigns(:users).all? { |u| u.to_s =~ /filtered_index/ }
    assert assigns(:users).all? { |u| u.institutions.include?(institution) }
    assert_not_equal assigns(:users).size, User.count
    assert_select '#unexpected_error', false
    assert_template 'users/index'
  end

  test 'should get institution filtered index in json' do
    institution = login_into_institution

    Fabricate(:user, lastname: 'in_filtered_index') # No match, outside institution

    3.times do
      Fabricate(:user, lastname: 'in_filtered_index').tap do |user|
        Fabricate(:job, user_id: user.id, institution_id: institution.id)
      end
    end

    get :index, q: 'filtered_index', format: 'json'
    assert_response :success

    users = ActiveSupport::JSON.decode(@response.body)

    assert_equal 3, users.size
    assert users.all? { |s| s['label'].match /filtered_index/i }

    get :index, q: 'no_user', format: 'json'
    assert_response :success

    users = ActiveSupport::JSON.decode(@response.body)

    assert_equal 0, users.size
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
      patch :update, id: @user, user: Fabricate.attributes_for(:user, name: 'Upd')
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

  test 'should destroy user in current institution' do
    institution = Fabricate(:institution)
    job = Fabricate(:job, user_id: @user.id, institution_id: institution.id, job: 'janitor')

    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user

    assert job.active

    assert_no_difference('User.count') do
      delete :destroy, id: @user
    end

    assert !job.reload.active

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
      patch :update_profile, id: @user,
        user: Fabricate.attributes_for(:user, name: 'Upd')
    end

    assert_redirected_to edit_profile_users_url
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
      patch :update_profile, id: another_user,
        user: Fabricate.attributes_for(:user, name: 'Upd')
    end

    assert_redirected_to edit_profile_users_url
    assert_not_equal 'Upd', another_user.reload.name
    assert_equal 'Upd', @user.reload.name
  end

  test 'should find the user by email' do
    institution = login_into_institution

    get :find_by_email, q: @user.email, format: 'js'
    assert_response :success

    assert_template 'users/edit'
  end

  test 'should find the user by email with job' do
    institution = login_into_institution
    another_user = Fabricate(:user)
    job = Fabricate(:job, institution_id: institution.id)

    get :find_by_email, q: another_user.email, format: 'js'
    assert_response :success

    assert_template 'jobs/_job'
  end

  test 'should not find the user by email' do
    institution = login_into_institution

    get :find_by_email, q: '', format: 'html'
    assert_response :success
  end

  private

  def login_into_institution
    institution = Fabricate(:institution)

    Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'janitor'
    )

    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user

    institution
  end
end
