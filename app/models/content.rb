class Content < ActiveRecord::Base
  has_paper_trail
  
  has_magick_columns title: :string
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :content, :documents_attributes, :lock_version

  # Default order
  default_scope order("#{table_name}.title ASC")
  
  # Validations
  validates :title, :teach_id, presence: true
  validates :title, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :teach
  has_many :documents, as: :owner, dependent: :destroy
  has_one :school, through: :teach

  accepts_nested_attributes_for :documents, allow_destroy: true,
    reject_if: ->(attrs) {
      ['file', 'file_cache', 'name'].all? { |a| attrs[a].blank? }
    }

  def to_s
    self.title
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
