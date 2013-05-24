module Contents::Navigation
  extend ActiveSupport::Concern

  module ClassMethods
    def prev_for(content)
      where("#{table_name}.title < ?", content.title).last
    end

    def next_for(content)
      where("#{table_name}.title > ?", content.title).first
    end
  end
end
