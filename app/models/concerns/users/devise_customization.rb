module Users
  module DeviseCustomization
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :recoverable, :rememberable, :trackable,
        :validatable
    end

    module ClassMethods
      def find_by_email_and_subdomain(email, subdomain)
        joins(:institutions).where(
          [
            "#{table_name}.email = :email",
            "#{Institution.table_name}.identification = :subdomain"
          ].join(' AND '),
          email: email.to_s.downcase.strip, subdomain: subdomain
        ).readonly(false).first
      end

      def custom_find_for_authentication(conditions = {})
        subdomains = conditions.delete(:subdomains)

        if subdomains.blank? || RESERVED_SUBDOMAINS.include?(subdomains.first)
          user = find_by_email(conditions[:email].to_s.downcase.strip)

          user && (user.is?(:admin) || user.institutions.present?) ? user : nil
        else
          find_by_email_and_subdomain(conditions[:email], subdomains.first)
        end
      end
    end
  end
end
