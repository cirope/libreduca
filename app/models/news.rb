class News < ActiveRecord::Base
  has_paper_trail

  has_magick_columns title: :string

  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :description, :body, :institution_id, :lock_version
  
  # Default order
  default_scope order("#{table_name}.created_at DESC")

  # Validations
  validates :title, :institution_id, presence: true
  validates :title, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :institution
  has_many :comments, as: :commentable, dependent: :destroy

  def to_s
    self.title
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
