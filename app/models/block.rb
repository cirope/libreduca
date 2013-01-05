class Block < ActiveRecord::Base
  has_paper_trail

  attr_accessible :id, :content, :position, :lock_version

  # Default order
  default_scope order("#{table_name}.position ASC")

  # Validations
  validates :content, presence: true, allow_blank: true

  belongs_to :blockable, polymorphic: true
end
