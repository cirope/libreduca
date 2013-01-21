class Job < ActiveRecord::Base
  has_paper_trail
  
  TYPES = ['headmaster', 'teacher', 'janitor', 'student']
  
  # Scopes
  scope :exclude_studens, where('job <> ?', 'student')
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :job, :description, :user_id, :institution_id,
    :auto_institution_name, :lock_version
  
  attr_accessor :auto_institution_name
  
  # Validations
  validates :job, :institution_id, presence: true
  validates :job, inclusion: { in: TYPES }, allow_nil: true, allow_blank: true
  validates :job, :description, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  # Relations
  belongs_to :user
  belongs_to :institution
  
  def self.in_institution(institution)
    where(institution_id: institution.id)
  end

  TYPES.each do |type|
    define_method("#{type}?") { self.job == type }
  end
end
