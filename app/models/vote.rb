class Vote < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :vote_flag, :lock_version

  attr_readonly :user_id, :votable_id, :votable_type

  # Callbacks
  before_destroy -> { false }

  # Scopes
  scope :positives, -> { where(vote_flag: true ) }
  scope :negatives, -> { where(vote_flag: false) }

  # Validations
  validates :vote_flag, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  # Relations
  belongs_to :user
  belongs_to :votable, polymorphic: true
end
