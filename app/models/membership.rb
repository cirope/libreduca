class Membership < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :user_id, :group_id, :auto_group_name, :auto_user_name

  attr_accessor :auto_group_name, :auto_user_name

  # Validations
  validates :user_id, uniqueness: { scope: :group_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :user
  belongs_to :group

  def to_s
    self.user.to_s
  end
end
