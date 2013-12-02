class DeviseBackgrounder
  def self.confirmation_instructions(record, token, options = {})
    new(:confirmation_instructions, record, token, options)
  end

  def self.reset_password_instructions(record, token, options = {})
    new(:reset_password_instructions, record, token, options)
  end

  def self.unlock_instructions(record, token, options = {})
    new(:unlock_instructions, record, token, options)
  end

  def initialize(method, record, token, options = {})
    @method, @record, @token, @options = method, record, token, options
  end

  def deliver
    Devise::Mailer.delay.send(@method, @record, @token, @options)
  end
end
