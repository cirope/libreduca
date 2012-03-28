class School < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns name: :string, identification: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :identification, :district_id, :lock_version
  
  # Default order
  default_scope order('name ASC')
  
  # Validations
  validates :name, :identification, :district_id, presence: true
  validates :name, :identification, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  validates :identification, format: { with: /\A[a-z\d]+(-[a-z\d]+)*\z/i },
    allow_nil: true, allow_blank: true
  validates :identification, uniqueness: { case_sensitive: false },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :district
  has_many :grades, dependent: :destroy
  
  def to_s
    [
      ("[#{self.identification}]" if self.identification.present?), self.name
    ].compact.join(' ')
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
