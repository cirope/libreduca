class Job < ActiveRecord::Base
  has_paper_trail
  
  TYPES = ['headmaster', 'teacher', 'janitor', 'student']
  
  # Scopes
  scope :exclude_studens, where('job <> ?', 'student')
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :job, :user_id, :school_id, :auto_school_name, :lock_version
  
  attr_accessor :auto_school_name
  
  # Validations
  validates :job, :school_id, presence: true
  validates :job, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :job, inclusion: { in: TYPES }, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :user
  belongs_to :school
  
  def self.in_school(school)
    where(school_id: school.id)
  end
end
