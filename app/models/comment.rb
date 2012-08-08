class Comment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :comment, :info, :lock_version

  # Default order
  default_scope order("#{table_name}.created_at ASC")

  # Validations
  validates :comment, :user_id, :forum_id, presence: true
  
  # Relations
  belongs_to :user
  belongs_to :forum

  def to_s
    self.comment
  end
end
