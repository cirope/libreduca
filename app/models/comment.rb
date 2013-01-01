class Comment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :comment, :info, :lock_version

  # Write once attributes
  attr_readonly :user_id

  # Default order
  default_scope order("#{table_name}.created_at ASC")

  # Validations
  validates :comment, :user_id, :commentable_id, presence: true
  
  # Relations
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  def to_s
    self.comment
  end

  def anchor
    "comment-#{self.id}"
  end
end
