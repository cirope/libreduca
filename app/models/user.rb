class User < ActiveRecord::Base
  include Comparable
  include RoleModel
  
  roles :admin, :regular
  
  has_paper_trail
  
  has_magick_columns name: :string, lastname: :string, email: :email
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :lastname, :email, :password, :password_confirmation,
    :role, :remember_me, :kinships_attributes, :jobs_attributes, :lock_version
  
  # Defaul order
  default_scope order("#{table_name}.lastname ASC")
  
  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  # Relations
  has_many :enrollments, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :kinships, dependent: :destroy
  has_many :inverse_kinships, class_name: 'Kinship', foreign_key: 'relative_id'
  has_many :relatives, through: :kinships
  has_many :dependents, through: :inverse_kinships, source: :user
  has_many :jobs, dependent: :destroy
  has_many :schools, through: :jobs
  
  accepts_nested_attributes_for :kinships, allow_destroy: true,
    reject_if: ->(attributes) {
      attributes['kin'].blank? && attributes['user_id'].blank?
    }
    
  accepts_nested_attributes_for :jobs, allow_destroy: true,
    reject_if: ->(attributes) {
      attributes['job'].blank? && attributes['school_id'].blank?
    }
  
  def initialize(attributes = {}, options = {})
    super(attributes, options)
    
    self.role ||= :regular
  end
  
  def to_s
    [self.name, self.lastname].compact.join(' ')
  end
  
  alias_method :label, :to_s
  
  def <=>(other)
    self_s = [self.lastname, self.name].join(' ')
    
    if other.kind_of?(User)
      self_s <=> [other.lastname, other.name].join(' ')
    else
      self_s <=> other.to_s
    end
  end
  
  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }
    
    super(default_options.merge(options || {}))
  end
  
  def role
    self.roles.first.try(:to_sym)
  end
  
  def role=(role)
    self.roles = [role]
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
  
  def self.find_by_email_and_subdomain(email, subdomain)
    joins(:schools).where(
      [
        "#{table_name}.email ILIKE :email",
        "#{School.table_name}.identification = :subdomain"
      ].join(' AND '),
      email: email, subdomain: subdomain
    ).readonly(false).first
  end
  
  def self.find_for_authentication(conditions = {})
    subdomains = conditions.delete(:subdomains)
    
    if subdomains.blank? || RESERVED_SUBDOMAINS.include?(subdomains.first)
      user_by_email = where(email: conditions[:email]).first
      
      user_by_email.try(:is?, :admin) ? user_by_email : nil
    else
      find_by_email_and_subdomain(conditions[:email], subdomains.first)
    end
  end
end
