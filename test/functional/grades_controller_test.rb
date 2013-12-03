require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  setup do
    @grade = Fabricate(:grade)
    @institution = @grade.institution

    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index, institution_id: @institution.to_param
    assert_response :success
    assert_not_nil assigns(:grades)
    assert_select '#unexpected_error', false
    assert_template 'grades/index'
  end

  test 'should get filtered index' do
    3.times do
      Fabricate(:grade, institution_id: @institution.id) do
        name { "in_filtered_index #{sequence(:grade_name)}" }
      end
    end

    get :index, institution_id: @institution.to_param, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:grades)
    assert_equal 3, assigns(:grades).size
    assert assigns(:grades).all? { |g| g.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:grades).size, @institution.grades.count
    assert_select '#unexpected_error', false
    assert_template 'grades/index'
  end

  test 'should get new' do
    get :new, institution_id: @institution.to_param
    assert_response :success
    assert_not_nil assigns(:grade)
    assert_select '#unexpected_error', false
    assert_template 'grades/new'
  end

  test 'should create grade' do
    assert_difference('Grade.count') do
      post :create, institution_id: @institution.to_param,
        grade: Fabricate.attributes_for(:grade)
    end

    assert_redirected_to institution_grade_url(@institution, assigns(:grade))
  end

  test 'should show grade' do
    get :show, institution_id: @institution.to_param, id: @grade
    assert_response :success
    assert_not_nil assigns(:grade)
    assert_select '#unexpected_error', false
    assert_template 'grades/show'
  end

  test 'should get edit' do
    get :edit, institution_id: @institution.to_param, id: @grade
    assert_response :success
    assert_not_nil assigns(:grade)
    assert_select '#unexpected_error', false
    assert_template 'grades/edit'
  end

  test 'should update grade' do
    assert_no_difference 'Grade.count' do
      patch :update, institution_id: @institution.to_param, id: @grade,
        grade: Fabricate.attributes_for(:grade, name: 'Upd')
    end

    assert_redirected_to institution_grade_url(@institution, assigns(:grade))
    assert_equal 'Upd', @grade.reload.name
  end

  test 'should destroy grade' do
    assert_difference('Grade.count', -1) do
      delete :destroy, institution_id: @institution.to_param, id: @grade
    end

    assert_redirected_to institution_grades_url(@institution)
  end
end
