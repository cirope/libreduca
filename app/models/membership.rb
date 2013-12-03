class Membership < ActiveRecord::Base
  include Associations::DestroyPaperTrail

  has_paper_trail

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
