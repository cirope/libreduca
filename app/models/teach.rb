class Teach < ActiveRecord::Base
  has_paper_trail
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :start, :finish, :course_id, :enrollments_attributes,
    :lock_version
  
  # Default order
  default_scope order('start DESC')
  
  # Validations
  validates :start, :finish, :course_id, presence: true
  validates :start, timeliness: { type: :date }, allow_nil: true,
    allow_blank: true
  validates :finish, timeliness: { after: :start, type: :date },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :course
  has_one :grade, through: :course
  has_one :school, through: :grade
  has_many :enrollments, dependent: :destroy
  
  accepts_nested_attributes_for :enrollments, allow_destroy: true,
    reject_if: ->(attributes) { attributes['user_id'].blank? }
  
  def to_s
    "#{self.course} ( #{I18n.l(self.start)} -> #{I18n.l(self.finish)} )"
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
end
