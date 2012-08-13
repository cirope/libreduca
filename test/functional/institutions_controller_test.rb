require 'test_helper'

class InstitutionsControllerTest < ActionController::TestCase
  setup do
    @institution = Fabricate(:institution)
    
    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:institutions)
    assert_select '#unexpected_error', false
    assert_template 'institutions/index'
  end
  
  test 'should get filtered index' do
    3.times { Fabricate(:institution, name: 'in_filtered_index') }
    
    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:institutions)
    assert_equal 3, assigns(:institutions).size
    assert assigns(:institutions).all? { |s| s.inspect =~ /filtered_index/ }
    assert_not_equal assigns(:institutions).size, Institution.count
    assert_select '#unexpected_error', false
    assert_template 'institutions/index'
  end
  
  test 'should get filtered index in json' do
    3.times { Fabricate(:institution, name: 'in_filtered_index') }
    
    get :index, q: 'filtered_index', format: 'json'
    assert_response :success
    
    institutions = ActiveSupport::JSON.decode(@response.body)
    
    assert_equal 3, institutions.size
    assert institutions.all? { |s| s['label'].match /filtered_index/i }
    
    get :index, q: 'no_institution', format: 'json'
    assert_response :success
    
    institutions = ActiveSupport::JSON.decode(@response.body)
    
    assert_equal 0, institutions.size
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:institution)
    assert_select '#unexpected_error', false
    assert_template 'institutions/new'
  end

  test 'should create institution' do
    assert_difference('Institution.count') do
      post :create, institution: Fabricate.attributes_for(:institution)
    end

    assert_redirected_to institution_url(assigns(:institution))
  end

  test 'should show institution' do
    get :show, id: @institution
    assert_response :success
    assert_not_nil assigns(:institution)
    assert_select '#unexpected_error', false
    assert_template 'institutions/show'
  end

  test 'should get edit' do
    get :edit, id: @institution
    assert_response :success
    assert_not_nil assigns(:institution)
    assert_select '#unexpected_error', false
    assert_template 'institutions/edit'
  end

  test 'should update institution' do
    assert_no_difference 'Institution.count' do
      put :update, id: @institution,
        institution: Fabricate.attributes_for(:institution, name: 'Upd')
    end
    
    assert_redirected_to institution_url(assigns(:institution))
    assert_equal 'Upd', @institution.reload.name
  end

  test 'should destroy institution' do
    assert_difference('Institution.count', -1) do
      delete :destroy, id: @institution
    end

    assert_redirected_to institutions_url
  end
end
