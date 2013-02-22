module Users
  module Comparable
    extend ActiveSupport::Concern

    included do
      include ::Comparable
    end

    def <=>(other)
      self_s = [self.lastname, self.name].join(' ')

      if other.kind_of?(User)
        self_s <=> [other.lastname, other.name].join(' ')
      else
        self_s <=> other.to_s
      end
    end

    def ==(other)
      if other.kind_of?(User)
        if self.persisted?
          self.id == other.id
        else
          self.object_id == other.object_id
        end
      else
        false
      end
    end
  end
end
