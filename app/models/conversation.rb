class Conversation < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :comments_attributes, :lock_version

  # Callbacks
  before_destroy -> { false }

  # Default order
  default_scope order("#{table_name}.created_at DESC")

  # Relations
  belongs_to :conversable, polymorphic: true
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :comments

  def can_vote_comments?
    false
  end

  def users_to_notify(user, institution)
    self.users.is_not(user)
  end
end
