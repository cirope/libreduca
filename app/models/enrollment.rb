class Enrollment < ActiveRecord::Base
  include Associations::DestroyPaperTrail

  has_paper_trail

  # Scopes
  scope :sorted_by_name, -> { joins(:course).order("#{Course.table_name}.name ASC") }
  scope :only_students, -> { where(job: 'student') }

  attr_accessor :auto_user_name, :auto_enrollable_name

  # Callbacks
  before_validation :set_job, on: :create

  # Validations
  validates :job, :enrollable_id, presence: true
  validates :enrollable_id, uniqueness: { scope: :teach_id }, allow_blank: true,
    allow_nil: true
  validates :job, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :job, inclusion: { in: Job::TYPES }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :teach
  belongs_to :enrollable, polymorphic: true
  has_one :course, through: :teach
  has_one :grade, through: :course
  has_one :institution, through: :grade


  def to_s
    [self.enrollable].compact.join(' ')
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def set_job
    if self.enrollable && self.teach
      institution = self.institution || self.teach.institution || self.teach.grade.institution
      if self.enrollable_type == 'User'
        self.job = self.enrollable.jobs.in_institution(institution).first.try(:job)
      else
        self.job = 'student'
      end
    end
  end

  def score_average
    self.scores.weighted_average
  end

  def scores
    self.teach.scores.of_user(self.enrollable)
  end

  def send_email_summary
    Notifier.delay.enrollment_status(self)
  end

  def method_missing(method, *args, &block)
    if method.to_s =~ /^is_(\w+)\?$/
      self.job == $1
    else
      super
    end
  end

  def self.for_user(user)
    where("#{table_name}.enrollable_id = ?", user.id)
  end

  def self.in_institution(institution)
    joins(:institution).where(
      "#{Institution.table_name}.id = ?", institution.id
    )
  end

  def self.in_current_teach
    joins(:teach).where(
      [
        "#{Teach.table_name}.start <= :today",
        "#{Teach.table_name}.finish >= :today"
      ].join(' AND '),
      today: Time.zone.today
    )
  end
end
