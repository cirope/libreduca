module Application::Enrollments
  extend ActiveSupport::Concern

  included do
    before_filter :load_enrollments
  end

  def current_enrollments
    @_enrollments
  end

  def load_enrollments
    if current_user && current_institution
      @_enrollments = current_user.enrollments.in_institution(
        current_institution
      ).sorted_by_name.in_current_teach
    end
  end
end
