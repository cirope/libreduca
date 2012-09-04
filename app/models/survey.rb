class Survey < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :questions_attributes, :lock_version

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :content
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? }

  def to_s
    self.name
  end
end
