class Survey < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :lock_version

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :content

  def to_s
    self.name
  end
end
