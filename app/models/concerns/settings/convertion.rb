module Settings
  module Convertion
    extend ActiveSupport::Concern

    included do
      KINDS = ['String', 'Integer', 'Float', 'TrueClass', 'FalseClass']
    end

    def converted_value
      @_value ||
        case self.kind
        when 'String'
          self.value.to_s
        when 'Integer'
          self.value.to_i
        when 'Float'
          self.value.to_f
        when 'TrueClass', 'FalseClass'
          self.value.to_s == 'true' || self.value.to_s == 't' || self.value.to_i == 1
        end
    end

    def input_type
      case self.kind
      when 'String', 'Integer', 'Float'
        :string
      when 'TrueClass', 'FalseClass'
        :boolean
      end
    end
  end
end
