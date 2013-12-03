module Associations::DestroyInBatches
  extend ActiveSupport::Concern

  included do
    before_destroy :destroy_associations
  end

  private
    def destroy_associations
      self.class.reflect_on_all_associations(:has_many).each do |association|
        if association.options[:dependent] == :destroy
          self.send(association.name).find_each { |a| a.destroy }
        end
      end
    end
end
