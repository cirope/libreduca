module Visitable
  extend ActiveSupport::Concern

  included do
    has_many :visits, as: :visited, dependent: :destroy
  end

  def visited_by?(user)
    self.visits.where(user_id: user.id).exists?
  end

  def visited_by(user)
    self.visits.create!(user: user) unless self.visited_by?(user)
  end
end
