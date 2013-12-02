require 'test_helper'

class RouterControllerTest < ActionController::TestCase
  test 'should redirect to news' do
    institution = Fabricate(:institution)
    @request.host = "#{institution.identification}.lvh.me"

    3.times { Fabricate(:news, institution_id: institution.id) }

    get :index
    assert_redirected_to news_index_url
  end

  test 'should not redirect to news if has no news' do
    institution = Fabricate(:institution)
    @request.host = "#{institution.identification}.lvh.me"

    get :index
    assert_redirected_to new_user_session_url
  end

  test 'should not redirect to news if has show news false' do
    institution = Fabricate(:institution)
    @request.host = "#{institution.identification}.lvh.me"

    3.times { Fabricate(:news, institution_id: institution.id) }

    institution.show_news.update(value: false)

    get :index
    assert_redirected_to new_user_session_url
  end
end
