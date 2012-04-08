class Enrollment < ActiveRecord::Base
  has_paper_trail
  
  # Scopes
  scope :only_students, where(job: 'student')
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :teach_id, :user_id, :job, :auto_user_name, :lock_version
  
  attr_accessor :auto_user_name
  
  # Callbacks
  before_validation :set_job, on: :create
  
  # Validations
  validates :job, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :teach_id }, allow_blank: true,
    allow_nil: true
  validates :job, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :job, inclusion: { in: Job::TYPES }, allow_nil: true,
    allow_blank: true
  
  # Relations
  belongs_to :user
  belongs_to :teach
  has_one :course, through: :teach
  has_one :grade, through: :course
  has_one :school, through: :grade
  has_many :scores, through: :teach
  
  def set_job
    if self.user && self.teach
      school = self.school || self.teach.school || self.teach.grade.school
      
      self.job = self.user.jobs.in_school(school).first.try(:job)
    end
  end
  
  def score_average
    multipliers_sum = self.scores.sum(&:multiplier)
    
    if multipliers_sum > 0
      self.scores.map { |s| s.score * s.multiplier }.sum / multipliers_sum
    else
      0.0
    end
  end
  
  def self.in_school(school)
    joins(:school).where("#{School.table_name}.id = ?", school.id)
  end
  
  def self.in_current_teach
    joins(:teach).where(
      [
        "#{Teach.table_name}.start <= :today",
        "#{Teach.table_name}.finish >= :today"
      ].join(' AND '),
      today: Date.today
    )
  end
end
