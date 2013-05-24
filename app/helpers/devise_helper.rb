# encoding: utf-8

module DeviseHelper
  def devise_links_es
    @_devise_links = []
    
    add_link_to_back
    add_link_to_register
    add_link_to_forgot_password
    add_link_to_confirm_account
    add_link_to_unlock_account
    add_link_to_omniauth

    @_devise_links
  end

  private

  def add_link_to_back
    if controller_name != 'sessions'
      @_devise_links << link_to(
        'Volver a inicio de sesión', new_session_path(resource_name, embedded: params[:embedded])
      )
    end
  end

  def add_link_to_register
    if devise_mapping.registerable? && controller_name != 'registrations'
      @_devise_links << link_to('Registro', new_registration_path(resource_name))
    end
  end

  def add_link_to_forgot_password
    if devise_mapping.recoverable? && controller_name != 'passwords'
      @_devise_links << link_to(
        '¿Olvidaste tu contraseña?', new_password_path(resource_name, embedded: params[:embedded])
      )
    end
  end

  def add_link_to_confirm_account
    if devise_mapping.confirmable? && controller_name != 'confirmations'
      @_devise_links << link_to(
        '¿Querés confirmar tu cuenta?', new_confirmation_path(resource_name)
      )
    end
  end

  def add_link_to_unlock_account
    if devise_mapping.lockable? &&
        resource_class.unlock_strategy_enabled?(:email) &&
        controller_name != 'unlocks'
      @_devise_links << link_to(
        '¿Querés desbloquear tu cuenta?', new_unlock_path(resource_name)
      )
    end
  end

  def add_link_to_omniauth
    if devise_mapping.omniauthable?
      resource_class.omniauth_providers.each do |provider|
        @_devise_links << link_to(
          "Ingresar con #{provider.to_s.titleize}",
          omniauth_authorize_path(resource_name, provider)
        )
      end
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
