class Setting < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :value

  # Defaul order
  default_scope order("#{table_name}.created_at ASC")

  # Validations
  validates :name, :value, presence: true
  validates :name, :value, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  belongs_to :configurable, polymorphic: true
end
