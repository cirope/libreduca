class CustomDeviseMailer < Devise::Mailer
  include MandrillHeaders
  include Roadie::Rails::Automatic
end
