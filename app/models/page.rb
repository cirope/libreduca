class Page < ActiveRecord::Base
  has_paper_trail

  attr_accessible :id, :lock_version, :institution_id

  validates :institution_id, uniqueness: true

  belongs_to :institution
  has_many :blocks, as: :blockable, dependent: :destroy

  def page
    self.page.try(:blocks)
  end
end
