class Job < ActiveRecord::Base
  include Associations::DestroyPaperTrail

  has_paper_trail

  TYPES = ['headmaster', 'teacher', 'janitor', 'student']

  after_destroy :destroy_user

  # Scopes
  scope :exclude_studens, -> { where('job <> ?', 'student') }
  scope :active, -> { where(active: true) }

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

  private
    def destroy_user
      self.user.destroy! if Job.where(user_id: self.user.id).blank?
    end
end
