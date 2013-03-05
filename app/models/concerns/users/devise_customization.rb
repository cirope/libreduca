module Users
  module DeviseCustomization
    extend ActiveSupport::Concern

    included do
      devise :database_authenticatable, :recoverable, :rememberable, :trackable,
        :validatable
    end

    def send_instructions(attributes)
      generate_reset_password_token! if should_generate_reset_token?
      
      if self.welcome 
        instructions = attributes[:embedded] == 'true' ? 
          :token_instructions : :welcome_instructions
      else
        instructions = attributes[:embedded] == 'true' ?
          :embedded_reset_password_instructions : :reset_password_instructions
      end

      send_devise_notification(instructions)
    end

    module ClassMethods
      def find_by_email_and_subdomain(email, subdomain)
        joins(:institutions).where(
          [
            "#{table_name}.email ILIKE :email",
            "#{Institution.table_name}.identification = :subdomain"
          ].join(' AND '),
          email: email, subdomain: subdomain
        ).readonly(false).first
      end

      def custom_find_for_authentication(conditions = {})
        subdomains = conditions.delete(:subdomains)

        if subdomains.blank? || RESERVED_SUBDOMAINS.include?(subdomains.first)
          user = find_by_email(conditions[:email])

          user && (user.is?(:admin) || user.institutions.present?) ? user : nil
        else
          find_by_email_and_subdomain(conditions[:email], subdomains.first)
        end
      end

      def custom_send_reset_password_instructions(attributes = {})
        resource_params = attributes[:user]

        user = find_or_initialize_with_errors(
          reset_password_keys, resource_params, :not_found
        )

        user.welcome = resource_params[:welcome] == 'true'
        user.send_instructions(attributes) if user.persisted?

        user
      end 
    end
  end
end
