class Question < ActiveRecord::Base
  include Questions::Type
  include Questions::Users

  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :content, :hint, :question_type, :required, :answers_attributes, :lock_version

  # Scopes
  default_scope -> { order("#{table_name}.content ASC") }

  # Validations
  validates :content, :question_type, presence: true
  validates :content, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :survey
  has_many :answers, dependent: :destroy
  has_many :replies, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? }
  accepts_nested_attributes_for :replies, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? || attrs['answer_id'].blank? }

  def to_s
    self.content
  end
end
