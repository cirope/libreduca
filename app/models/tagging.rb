class Tagging < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :tag_id, :tag_attributes

  # Default order
  default_scope order("#{table_name}.created_at ASC")

  # Validations
  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type] }

  # Relations
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  accepts_nested_attributes_for :tag, reject_if: ->(attributes) { 
    ['name', 'category'].all? { |a| attributes[a].blank? } 
  }
end
