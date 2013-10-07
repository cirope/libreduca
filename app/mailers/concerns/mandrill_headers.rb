module MandrillHeaders
  def initialize(method_name = nil, *args)
    super.tap do
      add_mandrillapp_headers if method_name
    end
  end

  def add_mandrillapp_headers
    headers['X-MC-TrackingDomain'] = 'mail.libreduca.com'
    headers['X-MC-SigningDomain'] = 'mail.libreduca.com'
    headers['X-MC-Subaccount'] = 'libreduca'
  end
end
