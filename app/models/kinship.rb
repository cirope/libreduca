class Kinship < ActiveRecord::Base
  has_paper_trail
  
  TYPES = ['father', 'mother', 'tutor', 'superior', 'functional', 'other']
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :kin, :user_id, :relative_id, :auto_user_name, :lock_version
  
  attr_accessor :auto_user_name

  # Scopes
  scope :for_chart, -> { where(kin: ['superior', 'functional']) }
  
  # Validations
  validates :kin, :relative_id, presence: true
  validates :kin, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :kin, inclusion: { in: TYPES }, allow_nil: true, allow_blank: true
  
  # Relations
  belongs_to :user, inverse_of: :kinships
  belongs_to :relative, class_name: 'User'
end
