require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = Fabricate(:course)
    @grade = @course.grade

    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index, grade_id: @grade.to_param
    assert_response :success
    assert_not_nil assigns(:courses)
    assert_select '#unexpected_error', false
    assert_template 'courses/index'
  end

  test 'should get filtered index' do
    3.times do
      Fabricate(:course, grade_id: @grade.id) do
        name { "in_filtered_index #{sequence(:course_name)}" }
      end
    end

    get :index, grade_id: @grade.to_param, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:courses)
    assert_equal 3, assigns(:courses).size
    assert assigns(:courses).all? { |c| c.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:courses).size, @grade.courses.count
    assert_select '#unexpected_error', false
    assert_template 'courses/index'
  end

  test 'should get new' do
    get :new, grade_id: @grade.to_param
    assert_response :success
    assert_not_nil assigns(:course)
    assert_select '#unexpected_error', false
    assert_template 'courses/new'
  end

  test 'should create course' do
    assert_difference('Course.count') do
      post :create, grade_id: @grade.to_param,
        course: Fabricate.attributes_for(:course)
    end

    assert_redirected_to grade_course_url(@grade, assigns(:course))
  end

  test 'should show course' do
    get :show, grade_id: @grade.to_param, id: @course
    assert_response :success
    assert_not_nil assigns(:course)
    assert_select '#unexpected_error', false
    assert_template 'courses/show'
  end

  test 'should get edit' do
    get :edit, grade_id: @grade.to_param, id: @course
    assert_response :success
    assert_not_nil assigns(:course)
    assert_select '#unexpected_error', false
    assert_template 'courses/edit'
  end

  test 'should update course' do
    assert_no_difference 'Course.count' do
      put :update, grade_id: @grade.to_param, id: @course,
        course: Fabricate.attributes_for(:course, name: 'Upd')
    end

    assert_redirected_to grade_course_url(@grade, assigns(:course))
    assert_equal 'Upd', @course.reload.name
  end

  test 'should destroy course' do
    assert_difference('Course.count', -1) do
      delete :destroy, grade_id: @grade.to_param, id: @course
    end

    assert_redirected_to grade_courses_url(@grade)
  end
end
