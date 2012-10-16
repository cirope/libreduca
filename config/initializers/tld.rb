Libreduca::Application.configure do
  # Change default tld lenght
  config.action_dispatch.tld_length = APP_CONFIG['public_host'].count('.')
end
