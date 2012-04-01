class User < ActiveRecord::Base
  include RoleModel
  
  roles :admin, :regular
  
  has_paper_trail
  
  has_magick_columns name: :string, lastname: :string, email: :email
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :lastname, :email, :password, :password_confirmation,
    :roles, :remember_me, :jobs_attributes, :lock_version
  
  # Defaul order
  default_scope order('lastname ASC')
  
  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  # Relations
  has_many :jobs, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  
  accepts_nested_attributes_for :jobs, allow_destroy: true,
    reject_if: ->(attributes) {
      attributes['job'].blank? && attributes['school_id'].blank?
    }
  
  def to_s
    [self.name, self.lastname].compact.join(' ')
  end
  
  alias_method :label, :to_s
  
  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }
    
    super(default_options.merge(options || {}))
  end
  
  alias_method :old_roles, :roles
  
  def roles
    self.old_roles.map(&:to_sym)
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
