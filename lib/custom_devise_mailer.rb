class CustomDeviseMailer < Devise::Mailer
  include MandrillHeaders
end
