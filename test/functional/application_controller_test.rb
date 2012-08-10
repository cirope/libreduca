require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @controller.send :reset_session
    @controller.send 'response=', @response
    @controller.send 'request=', @request
  end
  
  test 'should set the current school from subdomain' do
    school = Fabricate(:school)
    
    assert_nil @controller.send(:current_school)
    
    @request.host = "#{school.identification}.libreduca.com"
    
    assert_not_nil @controller.send(:set_current_school)
    assert_equal school.id, @controller.send(:current_school).id
  end
end
