class News < ActiveRecord::Base
  has_paper_trail ignore: [
    :comments_count, :votes_positives_count, 
    :votes_negatives_count, :lock_version, :updated_at
  ]

  has_magick_columns title: :string

  attr_readonly :institution_id, :comments_count

  # Setup accessible (or protected) attributes for your model
  attr_accessible :title, :description, :body, :lock_version
  
  # Default order
  default_scope order("#{table_name}.created_at DESC")

  # Validations
  validates :title, :institution_id, presence: true
  validates :title, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :institution
  has_many :images, as: :owner, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :visits, as: :visited, dependent: :destroy

  def to_s
    self.title
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def anchor_vote
    "news-vote-#{self.id}"
  end

  def voted_by(user)
    self.votes.where(user_id: user.id).first
  end

  def visited_by?(user)
    self.visits.where(user_id: user.id).exists?
  end

  def visited_by(user)
    self.visits.create!(user: user) unless self.visited_by?(user)
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
