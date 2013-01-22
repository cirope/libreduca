class Page < ActiveRecord::Base
  has_paper_trail

  attr_readonly :institution_id

  # Setup accessible (or protected) attributes for your model
  attr_accessible :lock_version

  # Validations
  validates :institution_id, uniqueness: true

  # Relations
  belongs_to :institution
  has_many :blocks, as: :blockable, dependent: :destroy
end
