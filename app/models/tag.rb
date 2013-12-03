class Tag < ActiveRecord::Base
  include Associations::DestroyPaperTrail
  include Associations::DestroyInBatches

  has_paper_trail

  CATEGORIES = ['default', 'success', 'warning', 'important', 'info', 'inverse']

  has_magick_columns name: :string, tagger_type: :string

  alias_attribute :label, :to_s

  # Default order
  default_scope -> { order("#{table_name}.name DESC") }

  # Validations
  validates :name, :category, :tagger_type, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :institution_id },
    allow_nil: true, allow_blank: true
  validates :name, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :institution
  has_many :taggings, dependent: :destroy
  has_many :news, through: :taggings, source: :taggable, source_type: 'News'

  def initialize(attributes = {}, options = {})
    super

    self.category ||= 'info'
  end

  def to_s
    self.name
  end

  def as_json(options = nil)
    default_options = {
      only: [:id, :category],
      methods: :label
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
