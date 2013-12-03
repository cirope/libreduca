module Associations::DestroyPaperTrail
  extend ActiveSupport::Concern

  included do
    has_many :version_items, class_name: 'PaperTrail::Version',
      as: :item, dependent: :destroy
  end
end
