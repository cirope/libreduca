class DeviseNotifier < Devise::Mailer
  include MandrillHeaders

  def token_instructions(record, opts = {})
    devise_mail(record, :token_instructions, opts)
  end

  def embedded_reset_password_instructions(record, opts = {})
    devise_mail(record, :embedded_reset_password_instructions, opts)
  end

  def welcome_instructions(record, opts = {})
    devise_mail(record, :welcome_instructions, opts)
  end
end
