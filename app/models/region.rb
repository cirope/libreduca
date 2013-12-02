class Region < ActiveRecord::Base
  has_paper_trail

  has_magick_columns name: :string

  # Default order
  default_scope -> { order("#{table_name}.name ASC") }

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true,
    allow_blank: true

  # Relations
  has_many :districts, dependent: :destroy

  accepts_nested_attributes_for :districts, allow_destroy: true,
    reject_if: ->(attributes) { attributes['name'].blank? }

  def to_s
    self.name
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
