# Be sure to restart your server when you modify this file.

Libreduca::Application.config.session_store(
  :cookie_store,
  key: '_libreduca_session',
  domain: ".#{APP_CONFIG['public_host'].sub(/:.*/, '')}"
)

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Libreduca::Application.config.session_store :active_record_store
