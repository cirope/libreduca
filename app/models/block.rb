class Block < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :content, :position, :lock_version

  # Default order
  default_scope order("#{table_name}.position ASC")

  # Validations
  validates :content, :position, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :blockable, polymorphic: true
end
