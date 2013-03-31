module Institutions
  module Settings
    extend ActiveSupport::Concern

    included do
      DEFAULT_SETTINGS = {
        show_news: true
      }.with_indifferent_access.freeze

      after_initialize do |institution|
        institution.build_settings if institution.new_record? && institution.settings.empty?
      end

      accepts_nested_attributes_for :settings,
        reject_if: ->(attrs) { attrs['name'].blank? && attrs['value'].blank? }
    end

    def setting(name)
      self.settings.where(name: name).first || build_setting(name)
    end

    def method_missing(method, *args, &block)
      if DEFAULT_SETTINGS.member?(method)
        setting(method.to_s)
      else
        super
      end
    end

    def build_settings
      DEFAULT_SETTINGS.each do |name, value|
        build_setting(name) unless self.settings.detect { |s| s.name == name  }
      end

      self.settings
    end

    def build_setting(name)
      if DEFAULT_SETTINGS.member?(name)
        value = DEFAULT_SETTINGS[name]

        self.settings.build(
          name: name.to_s, kind: value.class.to_s, value: value
        )
      end
    end
  end
end
