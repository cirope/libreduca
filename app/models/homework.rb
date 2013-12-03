class Homework < ActiveRecord::Base
  include Associations::DestroyPaperTrail
  include Associations::DestroyInBatches

  has_paper_trail

  # Defaul order
  default_scope -> { order("#{table_name}.closing_at ASC") }

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :closing_at, timeliness: { type: :date, on_or_after: :today },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :content
  has_many :presentations, dependent: :destroy

  def to_s
    self.name
  end
end
