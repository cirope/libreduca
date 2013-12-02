module Application::Institutions
  extend ActiveSupport::Concern

  included do
    helper_method :current_institution

    before_action :set_current_institution
  end

  def current_institution
    @_current_institution
  end

  def set_current_institution
    unless RESERVED_SUBDOMAINS.include?(request.subdomains.first)
      @_current_institution ||= Institution.find_by_identification(
        request.subdomains.first
      )
    end
  end
end
