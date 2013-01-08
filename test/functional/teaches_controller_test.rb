require 'test_helper'

class TeachesControllerTest < ActionController::TestCase
  setup do
    @teach = Fabricate(:teach)
    @course = @teach.course
    
    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index, course_id: @course.to_param
    assert_response :success
    assert_not_nil assigns(:teaches)
    assert_select '#unexpected_error', false
    assert_template 'teaches/index'
  end

  test 'should get new' do
    get :new, course_id: @course.to_param
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/new'
  end

  test 'should create teach' do
    assert_difference('Teach.count') do
      post :create, course_id: @course.to_param,
        teach: Fabricate.attributes_for(:teach, course_id: @course.id)
    end

    assert_redirected_to teach_url(assigns(:teach))
  end

  test 'should show teach' do
    get :show, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/show'
  end

  test 'should get edit' do
    get :edit, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/edit'
  end

  test 'should update teach' do
    assert_no_difference 'Teach.count' do
      put :update, course_id: @course.to_param, id: @teach,
        teach: Fabricate.attributes_for(:teach, start: Date.tomorrow)
    end
    
    assert_redirected_to teach_url(assigns(:teach))
    assert_equal Date.tomorrow, @teach.reload.start
  end

  test 'should destroy teach' do
    assert_difference('Teach.count', -1) do
      delete :destroy, course_id: @course.to_param, id: @teach
    end

    assert_redirected_to course_teaches_url(@course)
  end

  test 'should show teach scores' do
    get :show_scores, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/show_scores'
  end

  test 'should show teach enrollments' do
    get :show_enrollments, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/show_enrollments'
  end

  test 'should show teach tracking' do
    get :show_tracking, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/show_tracking'
  end


  test 'should get edit teach scores' do
    get :edit_scores, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/edit_scores'
  end

  test 'should get edit teach enrollments' do
    get :edit_enrollments, course_id: @course.to_param, id: @teach
    assert_response :success
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'teaches/edit_enrollments'
  end

  test 'should send email summary' do
    Fabricate(:enrollment, teach_id: @teach.id, with_job: 'student').tap do |enrollment|
      Fabricate(:kinship, user_id: enrollment.user_id)
    end
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      xhr :post, :send_email_summary, course_id: @course.to_param, id: @teach
    end
    
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'teaches/send_email_summary'
  end
end
