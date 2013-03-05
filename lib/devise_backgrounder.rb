class DeviseBackgrounder
  def self.confirmation_instructions(record, options = {})
    new(:confirmation_instructions, record, options)
  end

  def self.reset_password_instructions(record, options = {})
    new(:reset_password_instructions, record, options)
  end

  def self.unlock_instructions(record, options = {})
    new(:unlock_instructions, record, options)
  end

  def self.token_instructions(record, options = {})
    new(:token_instructions, record, options)
  end

  def self.embedded_reset_password_instructions(record, options = {})
    new(:embedded_reset_password_instructions, record, options)
  end

  def self.welcome_instructions(record, options = {})
    new(:welcome_instructions, record, options)
  end

  def initialize(method, record, options)
    @method, @record, @options = method, record, options
  end
  
  def deliver
    DeviseNotifier.delay.send(@method, @record, @options)
  end
end
