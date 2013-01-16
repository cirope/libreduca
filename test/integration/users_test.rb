require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'scroll in endless index' do
    100.times { Fabricate(:user) }

    login

    visit users_path

    row_count = all('tr').size

    assert row_count < 101

    until row_count == 101
      page.execute_script 'window.scrollBy(0,10000)'

      assert page.has_css?("tr:nth-child(#{row_count + 1})")
      assert_equal row_count + WillPaginate.per_page, all('tr').size

      row_count = all('tr').size
    end
  end
end
