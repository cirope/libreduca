class Institution < ActiveRecord::Base
  include Configurable
  include Institutions::Overrides
  include Institutions::Settings
  include Associations::DestroyPaperTrail
  include Associations::DestroyInBatches

  has_paper_trail

  has_magick_columns name: :string, identification: :string

  after_destroy :destroy_district

  alias_attribute :label, :name
  alias_attribute :informal, :identification

  # Default order
  default_scope -> { order("#{table_name}.name ASC") }

  # Validations
  validates :name, :identification, :district_id, presence: true
  validates :name, :identification, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  validates :identification, format: { with: /\A[a-z\d]+(-[a-z\d]+)*\z/ },
    allow_nil: true, allow_blank: true
  validates :identification, uniqueness: { case_sensitive: false },
    allow_nil: true, allow_blank: true
  validates :identification, exclusion: { in: RESERVED_SUBDOMAINS },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :district
  has_many :workers, -> { where active: true }, dependent: :destroy,
    class_name: 'Job'
  has_many :inactive_workers, -> { where active: false }, dependent: :destroy,
    class_name: 'Job'
  has_many :users, through: :workers
  has_many :kinships, through: :users
  has_many :grades, dependent: :destroy
  has_many :courses, through: :grades
  has_many :teaches, through: :courses
  has_many :forums, dependent: :destroy, as: :owner
  has_many :images, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :tags, dependent: :destroy

  def institution
    self
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end

  private
    def destroy_district
      if Institution.where(district_id: self.district.id).blank?
        self.district.destroy!
      end
    end
end
