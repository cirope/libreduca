class Teach < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :start, :finish, :description, :course_id,
    :enrollments_attributes, :scores_attributes, :lock_version

  # Default order
  default_scope order("#{table_name}.start DESC")

  # Scopes
  scope :historic, -> { where("#{table_name}.start <= ?", Date.today) }

  # Validations
  validates :start, :finish, :course_id, presence: true
  validates :start, timeliness: { type: :date }, allow_nil: true,
    allow_blank: true
  validates :finish, timeliness: { after: :start, type: :date },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :course
  has_one :grade, through: :course
  has_one :institution, through: :grade
  has_many :enrollments, dependent: :destroy, after_add: :set_teach
  has_many :contents, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :users, through: :enrollments, source: :enrollable, source_type: 'User'
  has_many :surveys, through: :contents
  has_many :questions, through: :surveys
  has_many :forums, dependent: :destroy, as: :owner

  accepts_nested_attributes_for :enrollments, allow_destroy: true,
    reject_if: ->(attributes) { attributes['enrollable_id'].blank? }
  accepts_nested_attributes_for :scores, allow_destroy: true,
    reject_if: ->(attributes) { attributes['score'].blank? }

  def to_s
    "#{self.course} (#{self.date_range_s})"
  end

  def date_range_s
    "#{I18n.l(self.start, format: :minimal)} -> #{I18n.l(self.finish, format: :minimal)}"
  end

  def set_teach(enrollment)
    enrollment.teach = self
  end

  def current?
    Date.today.between?(self.start, self.finish)
  end

  def next?
    self.start > Date.today
  end

  def past?
    !self.next? && !self.current?
  end

  def enrollment_for(user)
    self.enrollments.for_user(user).first
  end

  def send_email_summary
    self.enrollments.each do |enrollment|
      enrollment.send_email_summary if enrollment.is_student?
    end
  end

  def next_content_for(content)
    self.contents.next_for(content)
  end

  def prev_content_for(content)
    self.contents.prev_for(content)
  end

  def self.in_institution(institution)
    self.joins(:institution).where(
      "#{Institution.table_name}.id = ?", institution.id
    )
  end
end
