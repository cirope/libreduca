module Configurable
  extend ActiveSupport::Concern

  included do
    has_many :settings, dependent: :destroy, as: :configurable
  end
end
