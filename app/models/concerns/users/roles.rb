module Users
  module Roles
    extend ActiveSupport::Concern

    included do
      include RoleModel

      roles :admin, :regular
    end

    def role
      self.roles.first.try(:to_sym)
    end

    def role=(role)
      self.roles = [role]
    end
  end
end
