class Score < ActiveRecord::Base
  has_paper_trail
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :score, :multiplier, :description, :user_id, :teach_id,
    :lock_version
  
  # Default order
  default_scope order('created_at ASC')
  
  # Validations
  validates :score, :multiplier, presence: true
  validates :score, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  }, allow_nil: true, allow_blank: true
  validates :multiplier, numericality: {
    greater_than_or_equal_to: 0, less_than: 1000
  }, allow_nil: true, allow_blank: true
  validates :description, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true
  
  # Relations
  belongs_to :teach
  belongs_to :user
  
  def self.of_user(user)
    where(user_id: user.id)
  end
  
  def self.weighted_average
    multipliers_sum = all.sum(&:multiplier)
    
    if multipliers_sum > 0
      all.map { |s| s.score * s.multiplier }.sum / multipliers_sum
    else
      0.0
    end
  end
end
