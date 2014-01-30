ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'sidekiq/testing/inline'

require_relative 'concerns/integration/login'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...

  def error_message_from_model(model, attribute, message, extra = {})
    ::ActiveModel::Errors.new(model).generate_message(attribute, message, extra)
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

# Custom extensions
require_relative 'support/integration_test'
require_relative 'support/shared_db_connection'
