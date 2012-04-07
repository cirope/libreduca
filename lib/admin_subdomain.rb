class AdminSubdomain
  def self.matches?(request)
    request.subdomain.blank? || RESERVED_SUBDOMAINS.include?(request.subdomains.first)
  end
end
