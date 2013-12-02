class Group < ActiveRecord::Base
  has_paper_trail

  has_magick_columns name: :string

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :institution_id, :memberships_attributes, :enrollable_type

  attr_accessor :enrollable_type

  # Validations
  validates :name, :institution_id, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :institution_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :institution
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :enrollments, as: :enrollable, dependent: :destroy

  accepts_nested_attributes_for :memberships, allow_destroy: true,
    reject_if: ->(attributes) { attributes['user_id'].blank? }

  def to_s
    [self.name].compact.join(' ')
  end

  alias_method :label, :to_s

  def informal
    self.class.model_name.human
  end

  def as_json(options = nil)
    self.enrollable_type = 'Group'

    default_options = {
      only: [:id],
      methods: [:label, :informal, :enrollable_type]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
