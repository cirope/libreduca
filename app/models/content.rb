class Content < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns title: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :lock_version

  # Default order
  default_scope order("#{table_name}.title ASC")
  
  # Validations
  validates :title, :teach_id, presence: true
  validates :title, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :teach

  def to_s
    self.title
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
