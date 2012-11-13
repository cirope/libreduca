class Membership < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :user_id, :group_id

  # Validations
  validates :user_id, :group_id, presence: true
  validates :user_id, uniqueness: { scope: :group_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :user
  belongs_to :group

  def to_s
    [self.user.to_s, self.group.to_s].join(' -> ')
  end
end
