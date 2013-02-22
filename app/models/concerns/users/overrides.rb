module Users
  module Overrides
    extend ActiveSupport::Concern

    def initialize(attributes = {}, options = {})
      super(attributes, options)

      self.role ||= :regular
    end

    def to_s
      [self.name, self.lastname].compact.join(' ')
    end

    alias_method :label, :to_s


    def as_json(options = nil)
      default_options = {
        only: [:id],
        methods: [:label]
      }

      super(default_options.merge(options || {}))
    end
  end
end
