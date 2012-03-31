class Teach < ActiveRecord::Base
  has_paper_trail
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :start, :finish, :course_id, :lock_version
  
  # Default order
  default_scope order('start ASC')
  
  # Validations
  validates :start, :finish, :course_id, presence: true
  validates :start, timeliness: { type: :date }, allow_nil: true,
    allow_blank: true
  validates :finish, timeliness: { after: :start, type: :date },
    allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :course
  
  def to_s
    "#{self.course} ( #{I18n.l(self.start)} -> #{I18n.l(self.finish)} )"
  end
end
