require 'test_helper'

class SchoolsControllerTest < ActionController::TestCase
  setup do
    @school = Fabricate(:school)
    
    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:schools)
    assert_select '#unexpected_error', false
    assert_template 'schools/index'
  end
  
  test 'should get filtered index' do
    3.times { Fabricate(:school, name: 'in_filtered_index') }
    
    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:schools)
    assert_equal 3, assigns(:schools).size
    assert assigns(:schools).all? { |s| s.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:schools).size, School.count
    assert_select '#unexpected_error', false
    assert_template 'schools/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:school)
    assert_select '#unexpected_error', false
    assert_template 'schools/new'
  end

  test 'should create school' do
    assert_difference('School.count') do
      post :create, school: Fabricate.attributes_for(:school)
    end

    assert_redirected_to school_url(assigns(:school))
  end

  test 'should show school' do
    get :show, id: @school
    assert_response :success
    assert_not_nil assigns(:school)
    assert_select '#unexpected_error', false
    assert_template 'schools/show'
  end

  test 'should get edit' do
    get :edit, id: @school
    assert_response :success
    assert_not_nil assigns(:school)
    assert_select '#unexpected_error', false
    assert_template 'schools/edit'
  end

  test 'should update school' do
    assert_no_difference 'School.count' do
      put :update, id: @school,
        school: Fabricate.attributes_for(:school, name: 'Upd')
    end
    
    assert_redirected_to school_url(assigns(:school))
    assert_equal 'Upd', @school.reload.name
  end

  test 'should destroy school' do
    assert_difference('School.count', -1) do
      delete :destroy, id: @school
    end

    assert_redirected_to schools_url
  end
end
