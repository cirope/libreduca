module Institutions
  module Overrides
    extend ActiveSupport::Concern

    def to_s
      self.name
    end

    def inspect
      [
        ("[#{self.identification}]" if self.identification.present?), self.name
      ].compact.join(' ')
    end

    def as_json(options = nil)
      default_options = {
        only: [:id],
        methods: [:label, :informal]
      }

      super(default_options.merge(options || {}))
    end
  end
end
