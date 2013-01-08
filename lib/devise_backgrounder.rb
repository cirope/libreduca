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
  
  def initialize(method, record, options)
    @method, @record, @options = method, record, options
  end
  
  def deliver
    Devise::Mailer.delay.send(@method, @record, @options)
  end
end
