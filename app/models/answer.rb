class Answer < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope -> { order("#{table_name}.content ASC") }

  # Validations
  validates :content, presence: true
  validates :content, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :question
  has_many :replies, dependent: :destroy

  def to_s
    self.content
  end
end
