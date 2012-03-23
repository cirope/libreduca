class District < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns name: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :region_id, :lock_version
  
  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :region_id }, allow_nil: true,
    allow_blank: true
  
  # Relations
  belongs_to :region
  
  def to_s
    self.name
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query).order('name ASC') : order('name ASC')
  end
end
