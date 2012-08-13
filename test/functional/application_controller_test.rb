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
end
