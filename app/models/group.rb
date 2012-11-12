class Group < ActiveRecord::Base
  has_paper_trail

  has_magick_columns name: :string

  attr_accessible :name, :institution_id

  # Defaul order
  default_scope order("#{table_name}.name ASC")
  
  # Validations
  validates :name, :institution_id, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :institution_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :institution

  def to_s
    self.name
  end
end
