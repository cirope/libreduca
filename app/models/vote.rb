class Vote < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :lock_version

  attr_readonly :user_id, :votable_id, :votable_type

  # Validations
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  # Relations
  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true
end
