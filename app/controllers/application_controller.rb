class ApplicationController < ActionController::Base
  include Application::Exceptions

  protect_from_forgery
  after_filter -> { expires_now if user_signed_in? }
  
  def user_for_paper_trail
    current_user.try(:id)
  end
  
  private
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    users_path
  end
end
