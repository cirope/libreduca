class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_school
  after_filter -> { expires_now if user_signed_in? }
  
  helper_method :current_school
  
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
  
  def user_for_paper_trail
    current_user.try(:id)
  end
  
  def current_school
    @current_school
  end
  
  private
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  
  def set_current_school
    @current_school = School.find_by_identification(request.subdomains.first)
  end
end
