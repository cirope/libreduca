class Course < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns name: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :grade_id, :lock_version
  
  # Default order
  default_scope order('name ASC')
  
  # Validations
  validates :name, :grade_id, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :grade_id, case_sensitive: false },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :grade
  has_one :school, through: :grade
  has_many :teaches, dependent: :destroy
  
  def to_s
    self.name
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
