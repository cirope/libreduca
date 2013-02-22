module Users
  module Chart
    extend ActiveSupport::Concern

    included do
      # Scopes
      scope :roots_for_chart, -> {
        where(
          [
            "#{table_name}.kinships_in_chart_count = :zero",
            "#{table_name}.inverse_kinships_in_chart_count > :zero"
          ].join(' AND '),
          zero: 0
        )
      }
    end
  end
end
