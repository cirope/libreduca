class Kinship < ActiveRecord::Base
  include Kinships::Chart

  has_paper_trail

  KINDS = ['father', 'mother', 'tutor', 'superior', 'functional', 'other']

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :kin, :user_id, :relative_id, :auto_user_name, :lock_version

  attr_accessor :auto_user_name

  # Validations
  validates :kin, :relative_id, presence: true
  validates :kin, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :kin, inclusion: { in: KINDS }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :user
  belongs_to :relative, class_name: 'User'

  KINDS.each do |kind|
    define_method("#{kind}?") { self.kin == kind }
  end
end
