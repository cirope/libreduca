class Presentation < ActiveRecord::Base
  include Commentable

  has_paper_trail ignore: :comments_count

  mount_uploader :file, FileUploader

  # Callbacks
  before_save :check_current_teach, :update_file_attributes

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :file, :file_cache, :lock_version

  # Attributes only writables in creation
  attr_readonly :user_id, :homework_id

  # Default order
  default_scope -> { order("#{table_name}.created_at ASC") }

  # Validations
  validates :file, presence: true
  validates :homework_id, uniqueness: { scope: :user_id }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :user
  belongs_to :homework
  has_one :content, through: :homework
  has_one :teach, through: :content
  has_many :users, through: :comments

  def to_s
    self.file.present? ? self.file.file.identifier : '-'
  end

  def anchor
    "presentation-#{self.id}"
  end

  def check_current_teach
    unless self.homework.try(:content).try(:teach).try(:current?)
      raise 'You can not do this'
    end
  end

  def institution
    self.homework.content.institution
  end

  def self.for_homework(homework)
    self.where(homework_id: homework.id).first
  end

  def can_vote_comments?
    false
  end

  def users_to_notify(user, institution)
    self.users.is_not(user)
  end

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end
end
