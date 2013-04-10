module Application::Exceptions
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      begin
        @title = t('errors.title')
        if response.redirect_url.blank?
          render template: 'shared/show_error', locals: { error: exception }
        end

        logger.error(([exception, ''] + exception.backtrace).join("\n"))

      # In case the rescue explodes itself =)
      rescue => ex
        logger.error(([ex, ''] + ex.backtrace).join("\n"))
      end
    end

    rescue_from ::ActionController::RoutingError, ::ActiveRecord::RecordNotFound do |exception|
      @title = t('errors.title')

      render template: 'shared/show_404', locals: { error: exception }
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, alert: t('errors.access_denied')
    end
  end
end
