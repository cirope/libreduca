class Setting < ActiveRecord::Base
  include Settings::Convertion

  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :value, :kind

  # Defaul order
  default_scope order("#{table_name}.created_at ASC")

  # Validations
  validates :name, :kind, presence: true
  validates :name, :kind, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  validates :kind, inclusion: { in: KINDS }, allow_nil: true,
    allow_blank: false

  # Relations
  belongs_to :configurable, polymorphic: true

  def to_s
    self.name
  end
end
