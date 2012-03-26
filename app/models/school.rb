class School < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns name: :string, identification: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :identification, :lock_version
  
  # Default order
  default_scope order('name ASC')
  
  # Validations
  validates :name, presence: true
  validates :name, :identification, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  def to_s
    [
      ("[#{self.identification}]" if self.identification), self.name
    ].compact.join(' ')
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
