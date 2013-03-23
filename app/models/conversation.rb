class Conversation < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :comments_attributes, :lock_version

  # Default order
  default_scope order("#{table_name}.created_at DESC")

  # Relations
  belongs_to :conversable, polymorphic: true #, counter_cache: true
  has_many :participants, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :visits, as: :visited, dependent: :destroy

  accepts_nested_attributes_for :comments, reject_if: ->(attrs) { 
    attrs['comment'].blank? 
  }

  def new_messages_count(user)
    new_messages(user).count
  end

  def has_new_messages?(user)
    new_messages(user).count > 0
  end

  def new_messages(user)
    self.comments.includes(:visits).where(
      "#{Visit.table_name}.user_id is null AND #{Comment.table_name}.user_id != ?", user
    )
  end

  def comments_partial_path
    'conversations/comment'
  end
end
