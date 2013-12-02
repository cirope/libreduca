module Contents::MagickColumns
  extend ActiveSupport::Concern

  included do
    has_magick_columns title: :string
  end

  module ClassMethods
    def filtered_list(query)
      query.present? ? magick_search(query) : all
    end
  end
end
