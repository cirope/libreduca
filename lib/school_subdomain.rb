class SchoolSubdomain
  def self.matches?(request)
    request.subdomain.present? && RESERVED_SUBDOMAINS.exclude?(request.subdomains.first)
  end
end
