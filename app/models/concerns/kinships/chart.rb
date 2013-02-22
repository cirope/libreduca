module Kinships
  module Chart
    extend ActiveSupport::Concern

    included do
      # Constants
      CHART_KINDS = ['superior', 'functional']

      # Scopes
      scope :for_chart, -> { where(kin: CHART_KINDS) }

      # Callbacks
      after_create :increment_kinship_in_chart_count,
        :increment_inverse_kinship_in_chart_count
      after_destroy :decrement_kinship_in_chart_count,
        :decrement_inverse_kinship_in_chart_count
    end

    def in_chart?
      CHART_KINDS.include?(self.kin)
    end

    def increment_kinship_in_chart_count
      if self.in_chart?
        User.increment_counter(:kinships_in_chart_count, self.user_id)
      end
    end

    def decrement_kinship_in_chart_count
      if self.in_chart?
        User.decrement_counter(:kinships_in_chart_count, self.user_id)
      end
    end

    def increment_inverse_kinship_in_chart_count
      if self.in_chart?
        User.increment_counter(:inverse_kinships_in_chart_count, self.relative_id)
      end
    end

    def decrement_inverse_kinship_in_chart_count
      if self.in_chart?
        User.decrement_counter(:inverse_kinships_in_chart_count, self.relative_id)
      end
    end
  end
end
