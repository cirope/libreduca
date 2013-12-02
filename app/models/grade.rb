class Grade < ActiveRecord::Base
  has_paper_trail

  has_magick_columns name: :string

  # Default order
  default_scope -> { order("#{table_name}.name ASC") }

  # Validations
  validates :name, :institution_id, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :institution_id, case_sensitive: false },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :institution
  has_many :courses, dependent: :destroy

  def to_s
    self.name
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
