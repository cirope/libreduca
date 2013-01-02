module BlocksHelper
  def upper_login_button?
    !user_signed_in? && excluded_controllers && !empty_page?(current_institution)
  end

  def excluded_controllers
    (controller_name != 'sessions') && (controller_name != 'passwords')
  end
end
