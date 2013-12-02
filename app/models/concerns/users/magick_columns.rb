module Users
  module MagickColumns
    extend ActiveSupport::Concern

    included do
      has_magick_columns name: :string, lastname: :string, email: :email
    end

    module ClassMethods
      def filtered_list(query)
        query.present? ? magick_search(query) : all
      end
    end
  end
end
