module Application::Exceptions
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      begin
        if exception.kind_of? CanCan::AccessDenied
          redirect_to root_url, alert: t('errors.access_denied')
        else
          @title = t('errors.title')
          
          if response.redirect_url.blank?
    render template: 'shared/show_error', locals: { error: exception }
          end

          logger.error(([exception, ''] + exception.backtrace).join("\n"))
        end

      # In case the rescue explodes itself =)
      rescue => ex
        logger.error(([ex, ''] + ex.backtrace).join("\n"))
      end
    end
  end
end
