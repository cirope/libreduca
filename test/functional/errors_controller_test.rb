require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test 'should get error_404' do
    get :error_404
    assert_response :success
    assert_select '#error_404'
  end
end
