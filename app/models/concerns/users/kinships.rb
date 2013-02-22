module Users
  module Kinships
    extend ActiveSupport::Concern

    included do
      has_many :kinships, dependent: :destroy
      has_many :inverse_kinships, class_name: 'Kinship', foreign_key: 'relative_id'
      has_many :relatives, through: :kinships
      has_many :dependents, through: :inverse_kinships, source: :user

      accepts_nested_attributes_for :kinships, allow_destroy: true,
        reject_if: ->(attributes) {
          attributes['kin'].blank? && attributes['user_id'].blank?
        }
    end
  end
end
