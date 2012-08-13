require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(:job, user_id: user.id, institution_id: institution.id)
    @request.host = "#{institution.identification}.lvh.me"
    
    sign_in user
  end
  
  test 'should get index' do
    get :index
    assert_redirected_to action: @job.job
  end
  
  test 'should get headmaster dashboard' do
    assert @job.update_attribute :job, 'headmaster'
    get :headmaster
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'dashboard/headmaster'
  end
  
  test 'should get janitor dashboard' do
    assert @job.update_attribute :job, 'janitor'
    get :janitor
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'dashboard/janitor'
  end
  
  test 'should get student dashboard' do
    assert @job.update_attribute :job, 'student'
    get :student
    assert_response :success
    assert_not_nil assigns(:enrollments)
    assert_select '#unexpected_error', false
    assert_template 'dashboard/student'
  end
  
  test 'should get teacher dashboard' do
    assert @job.update_attribute :job, 'teacher'
    get :teacher
    assert_response :success
    assert_not_nil assigns(:enrollments)
    assert_select '#unexpected_error', false
    assert_template 'dashboard/teacher'
  end
end
