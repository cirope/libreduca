require 'test_helper'

class LaunchpadControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:institutions)
    assert_select '#unexpected_error', false
    assert_template 'launchpad/index'
  end
end
