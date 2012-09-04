class Question < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :content, :lock_version

  # Validations
  validates :content, presence: true
  validates :content, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :survey

  def to_s
    self.content
  end
end
