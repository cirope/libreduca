module Application::Exceptions
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, alert: t('errors.access_denied')
    end
  end
end
