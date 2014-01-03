class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters
  include Application::Enrollments
  include Application::Exceptions
  include Application::Institutions

  protect_from_forgery

  before_action :set_js_format_in_iframe_request

  after_filter -> { expires_now if user_signed_in? }

  def user_for_paper_trail
    current_user.try(:id)
  end

  def current_ability
    @_current_ability ||= Ability.new(current_user, current_institution)
  end

  def redirect_to_back_or(default_url, *args)
    redirect_to :back, *args
  rescue ActionController::RedirectBackError
    redirect_to default_url, *args
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    return_url = session[:user_return_to]

    if return_url.present?
      return_url
    else
      if resource.is?(:admin)
        institutions_url
      else
        count = resource.institutions.count

        if count > 1
          launchpad_url
        elsif count == 1
          dashboard_url(subdomain: resource.institutions.first.identification)
        else
          dashboard_url
        end
      end
    end
  end

  def set_js_format_in_iframe_request
    request.format = :js if params['X-Requested-With'] == 'IFrame'
  end
end
