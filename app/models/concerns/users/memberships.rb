module Users
  module Memberships
    extend ActiveSupport::Concern

    included do
      has_many :memberships, dependent: :destroy
      has_many :groups, through: :memberships

      accepts_nested_attributes_for :memberships, allow_destroy: true,
        reject_if: ->(attributes) {
          attributes['group_id'].blank?
        }
    end
  end
end
