class Score < ActiveRecord::Base
  has_paper_trail
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :score, :multiplier, :description, :user_id, :teach_id,
    :lock_version
  
  # Default order
  default_scope order('created_at ASC')
  
  # Validations
  validates :score, :multiplier, presence: true
  validates :score, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  }, allow_nil: true, allow_blank: true
  validates :multiplier, numericality: {
    greater_than_or_equal_to: 0, less_than: 1000
  }, allow_nil: true, allow_blank: true
  validates :description, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  # Relations
  belongs_to :teach
  belongs_to :user
end
