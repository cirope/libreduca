require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    @institution = Fabricate(:institution)
    @page = Fabricate(:page, institution_id: @institution.id)
    @block = Fabricate(:block, blockable_id: @page.id, blockable_type: 'Page')

    @request.host = "#{@institution.identification}.libreduca.com"
  end

  test "should get show of page without blocks and no user" do
    get :show, page_id: @page.to_param
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'pages/show'
    assert_template 'devise/sessions/new_miniform'
  end

  test "should get show of page with blocks and no user" do
    get :show, page_id: @page.to_param
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'pages/show'
    assert_template 'devise/sessions/new'
    assert_template 'blocks/_block'
    assert_template 'blocks/_form'
  end

  test "should get show of page with blocks and user" do
    sign_in Fabricate(:user, password: '123456', roles: [:janitor])

    get :show, page_id: @page.to_param
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'pages/show'
    assert_template 'blocks/_block'
    assert_template 'blocks/_form'
  end
end