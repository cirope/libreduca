class District < ActiveRecord::Base
  include Associations::DestroyPaperTrail
  include Associations::DestroyInBatches

  has_paper_trail

  has_magick_columns name: :string

  after_destroy :destroy_region

  # Default order
  default_scope -> { order("#{table_name}.name ASC") }

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :name, uniqueness: { scope: :region_id, case_sensitive: false },
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :region
  has_many :institutions

  def to_s
    self.name
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end

  private
    def destroy_region
      self.region.destroy! if District.where(region_id: self.region.id).blank?
    end
end
