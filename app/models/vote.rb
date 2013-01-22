class Vote < ActiveRecord::Base
  has_paper_trail on: [:update]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :vote_flag, :lock_version

  attr_readonly :user_id, :votable_id, :votable_type

  # Callbacks
  before_save :votable_count
  before_destroy -> { false }

  # Scopes
  scope :positives, -> { where(vote_flag: true ) }
  scope :negatives, -> { where(vote_flag: false) }

  # Validations
  validates :vote_flag, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  # Relations
  belongs_to :user
  belongs_to :votable, polymorphic: true, autosave: true

  def votable_count
    if self.vote_flag_changed?
      if self.vote_flag
        increment_attribute(:votes_positives_count)
        decrement_attribute(:votes_negatives_count) if self.persisted? 
      else
        increment_attribute(:votes_negatives_count)
        decrement_attribute(:votes_positives_count) if self.persisted?
      end
    end
  end

  private

  def increment_attribute(attr)
    self.votable.send("#{attr}=", self.votable.send(attr) + 1)
  end

  def decrement_attribute(attr)
    self.votable.send("#{attr}=", self.votable.send(attr) - 1)
  end
end
