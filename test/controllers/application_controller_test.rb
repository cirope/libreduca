require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @controller.send :reset_session
    @controller.send 'response=', @response
    @controller.send 'request=', @request
  end

  test 'should set the current institution from subdomain' do
    institution = Fabricate(:institution)

    assert_nil @controller.send(:current_institution)

    @request.host = "#{institution.identification}.libreduca.com"

    assert_not_nil @controller.send(:set_current_institution)
    assert_equal institution.id, @controller.send(:current_institution).id
  end

  test 'should set the current enrollments' do
    teach = Fabricate(:teach)
    institution = teach.institution
    user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(
      :job, user_id: user.id, institution_id: institution.id, job: 'student'
    )

    teach.tap do |t|
      Fabricate :enrollment, teach_id: t.id, enrollable_id: user.id, job: 'student'
    end

    sign_in user

    @request.host = "#{institution.identification}.libreduca.com"

    assert_not_nil @controller.send(:set_current_institution)
    assert @controller.send(:current_enrollments).size > 0
    assert_equal user.enrollments.sorted_by_name.to_a,
      @controller.send(:current_enrollments).to_a
  end

  test 'should redirect to default' do
    @controller.send :redirect_to_back_or, '/test'

    assert_redirected_to '/test'
  end

  test 'should redirect to back' do
    request.env['HTTP_REFERER'] = '/test'

    @controller.send :redirect_to_back_or, '/no_way'

    assert_redirected_to '/test'
  end
end
