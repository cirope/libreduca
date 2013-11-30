class PasswordsController < Devise::PasswordsController

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params)

    if successfully_sent?(resource)
      if is_embedded?
        resource.reset_password_token = nil

        render :confirmation_token
      else
        redirect_to new_session_path(resource_name)
      end
    else
      render self.resource.welcome ? 'welcome' : 'new'
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
  end

  private

  def assert_reset_token_passed
    set_token

    self.resource = resource_class.find_or_initialize_with_error_by(
      :reset_password_token, @token
    )

    if @token.blank?
      self.resource.errors.add(:reset_password_token, :blank)

      render :confirmation_token
    elsif self.resource.persisted? && !self.resource.reset_password_period_valid?
      self.resource.errors.add(:reset_password_token, :expired)

      render :expired_token
    elsif self.resource.errors.any?
      render :confirmation_token
    end
  end

  def set_token
    @token = resource_params[:reset_password_token] if resource_params
    @token ||= params[:reset_password_token]

    @token.try(:strip!)
  end
end
