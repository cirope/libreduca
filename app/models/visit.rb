class Visit < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :user

  attr_readonly :user_id, :visited_id, :visited_type

  # Callbacks
  before_destroy -> { false }

  # Restrictions
  validates :user_id, uniqueness: { scope: [:visited_id, :visited_type] }

  # Relations
  belongs_to :user
  belongs_to :visited, polymorphic: true
end
