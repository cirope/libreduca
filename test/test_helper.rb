ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'sidekiq/testing/inline'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  
  def error_message_from_model(model, attribute, message, extra = {})
    ::ActiveModel::Errors.new(model).generate_message(attribute, message, extra)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false
  
  setup do
    Capybara.default_driver = :selenium
  end

  teardown do
    # Truncate the database
    DatabaseCleaner.clean
    # Forget the (simulated) browser state
    Capybara.reset_sessions!
    # Revert Capybara.current_driver to Capybara.default_driver
    Capybara.use_default_driver
  end
  
  def login
    user = Fabricate(:user, password: '123456')
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '123456'
    
    find('.btn-primary.submit').click
    
    assert_equal users_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert.alert-info')
    
    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.sessions.signed_in'))
    end
  end
  
  def assert_page_has_no_errors!
    assert page.has_no_css?('#unexpected_error')
  end
end
