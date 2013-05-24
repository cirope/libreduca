module Application::Exceptions
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      begin
        if exception.kind_of? CanCan::AccessDenied
          redirect_to root_url, alert: t('errors.access_denied')
        else
          render_error_page(exception)
          log_exception(exception)
        end

      # In case the rescue explodes itself =)
      rescue => ex
        log_exception(ex)
      end
    end
  end

  private

  def render_error_page(exception)
    @title = t('errors.title')
    
    if response.redirect_url.blank?
      render template: 'shared/show_error', locals: { error: exception }
    end
  end

  def log_exception(exception)
    logger.error(([exception, ''] + exception.backtrace).join("\n"))
  end
end
