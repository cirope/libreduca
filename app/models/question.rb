class Question < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :content, :answers_attributes, :lock_version

  # Scopes
  default_scope order("#{table_name}.content ASC")

  # Validations
  validates :content, presence: true
  validates :content, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :survey
  has_many :answers, dependent: :destroy
  has_many :replies, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? }

  def to_s
    self.content
  end

  def has_been_answered_by?(user)
    self.replies.where(user_id: user.id).exists?
  end

  def reply_by(user)
    self.replies.where(user_id: user.id).first
  end
end
