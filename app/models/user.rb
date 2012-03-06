class User < ApplicationModel
  include RoleModel
  
  roles :admin, :regular
  
  has_paper_trail
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :lastname, :email, :password, :password_confirmation,
    :roles, :remember_me, :lock_version
  
  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  def to_s
    [self.name, self.lastname].compact.join(' ')
  end
  
  alias_method :old_roles, :roles
  
  def roles
    self.old_roles.map(&:to_sym)
  end
  
  def self.magick_columns
    [
      {field: 'lastname', operator: :like, mask: '%%%{t}%%', condition: %r{.*}},
      {field: 'name', operator: :like, mask: '%%%{t}%%', condition: %r{.*}},
      {field: 'email', operator: :like, mask: '%%%{t}%%', condition: %r{.+@.+}}
    ]
  end
  
  def self.filtered_list(query)
    query.present? ?
      magick_search(query).order('lastname ASC') : order('lastname ASC')
  end
end
