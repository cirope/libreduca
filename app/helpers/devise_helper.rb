# encoding: utf-8

module DeviseHelper
  def devise_links_es
    links = []
    
    if controller_name != 'sessions'
      links << link_to(
        'Volver a inicio de sesión', new_session_path(resource_name)
      )
    end

    if devise_mapping.registerable? && controller_name != 'registrations'
      links << link_to('Registro', new_registration_path(resource_name))
    end

    if devise_mapping.recoverable? && controller_name != 'passwords'
      links << link_to(
        '¿Olvidaste tu contraseña?', new_password_path(resource_name)
      )
    end

    if devise_mapping.confirmable? && controller_name != 'confirmations'
      links << link_to(
        '¿Querés confirmar tu cuenta?', new_confirmation_path(resource_name)
      )
    end

    if devise_mapping.lockable? &&
        resource_class.unlock_strategy_enabled?(:email) &&
        controller_name != 'unlocks'
      links << link_to(
        '¿Querés desbloquear tu cuenta?', new_unlock_path(resource_name)
      )
    end

    if devise_mapping.omniauthable?
      resource_class.omniauth_providers.each do |provider|
        links << link_to(
          "Ingresar con #{provider.to_s.titleize}",
          omniauth_authorize_path(resource_name, provider)
        )
      end
    end
    
    links
  end
end