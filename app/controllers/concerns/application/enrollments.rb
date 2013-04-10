module Application::Enrollments
  extend ActiveSupport::Concern

  included do
    helper_method :current_enrollments
  end

  def current_enrollments
    if current_user && current_institution
      current_user.enrollments.in_institution(
        current_institution
      ).sorted_by_name.in_current_teach
    end
  end
end
