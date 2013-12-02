require 'test_helper'

class WrongAccessTest < ActionDispatch::IntegrationTest
  test 'should show 404' do
    visit '/no_way'

    assert page.has_css?('#error_404')
  end
end
