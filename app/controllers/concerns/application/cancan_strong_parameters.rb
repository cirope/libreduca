module Application::CancanStrongParameters
  extend ActiveSupport::Concern

  included do
    before_action do
      resource = controller_name.singularize.to_sym
      method = "#{resource}_params"
      params[resource] &&= send(method) if respond_to?(method, true)
    end
  end
end
