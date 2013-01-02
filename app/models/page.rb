class Page < ActiveRecord::Base
  has_paper_trail

  attr_accessible :id, :lock_version, :institution_id, :blocks_attributes

  validates :institution_id, uniqueness: true

  belongs_to :institution
  has_many :blocks, as: :blockable, dependent: :destroy

  accepts_nested_attributes_for :blocks, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? }

  def page
    self.page.try(:blocks)
  end
end
