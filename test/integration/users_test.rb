require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'scroll in endless index' do
    100.times { Fabricate(:user) }

    login

    visit users_path

    row_count = all('tbody tr').size

    assert row_count < 101

    until row_count == 101
      page.execute_script 'window.scrollBy(0,10000)'

      assert page.has_css?("tbody tr:nth-child(#{row_count + 1})")

      row_count = all('tbody tr').size
    end
  end
end
