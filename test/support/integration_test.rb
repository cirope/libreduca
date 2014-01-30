class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  setup do
    Capybara.default_driver = :selenium
    Capybara.server_port = '54163'
    Capybara.app_host = 'http://admin.lvh.me:54163'
    Capybara.default_wait_time = ENV['TRAVIS'] ? 4 : 5
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def assert_page_has_no_errors!
    assert page.has_no_css?('#unexpected_error')
  end
end
