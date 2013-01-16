class Group < ActiveRecord::Base
  has_paper_trail

  has_magick_columns name: :string

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :institution_id, :memberships_attributes

  # Defaul order
  default_scope order("#{table_name}.name ASC")

  # Validations
  validates :name, :institution_id, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :institution_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :institution
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, source: :enrollable, source_type: 'Membership'

  accepts_nested_attributes_for :memberships, allow_destroy: true,
    reject_if: ->(attributes) { attributes['user_id'].blank? }

  def to_s
    [self.name].compact.join(' ')
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
