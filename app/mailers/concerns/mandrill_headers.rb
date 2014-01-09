module MandrillHeaders
  extend ActiveSupport::Concern

  included do
    after_action :add_mandrillapp_headers
  end

  private

  def add_mandrillapp_headers
    headers['X-MC-ReturnPathDomain'] = 'mail.libreduca.com'
    headers['X-MC-TrackingDomain']   = 'mail.libreduca.com'
    headers['X-MC-SigningDomain']    = 'mail.libreduca.com'
    headers['X-MC-Subaccount']       = 'libreduca'
  end
end
