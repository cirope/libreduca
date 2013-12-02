class News < ActiveRecord::Base
  include Visitable
  include Commentable

  self.per_page = 6

  has_paper_trail ignore: [
    :comments_count, :votes_count, :lock_version, :updated_at
  ]

  has_magick_columns title: :string

  attr_readonly :institution_id

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :description, :body, :published_at, :taggings_attributes, :lock_version

  # Callbacks
  before_validation :remove_duplicates_tags, :set_institution_to_tags

  # Default order
  default_scope -> { order("#{table_name}.created_at DESC") }

  # Validations
  validates :title, :published_at, presence: true
  validates :title, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :published_at, timeliness: { type: :datetime }, allow_nil: true,
    allow_blank: true

  # Relations
  belongs_to :institution
  has_many :images, as: :owner, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :taggings, allow_destroy: true, reject_if: ->(attributes) {
    attributes['tag_attributes']['name'].blank?
  }

  def initialize(attributes = {}, options = {})
    super

    self.published_at ||= Time.zone.now
  end

  def to_s
    self.title
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def remove_duplicates_tags
    tags = []

    self.taggings.reject! do |t|
      if tags.include?(t.tag.name)
        true
      else
        tags << t.tag.name
        false
      end
    end
  end

  def set_institution_to_tags
    self.taggings.select(&:new_record?).each do |t|
      t.tag.institution = self.institution if t.tag.new_record?
    end
  end

  def anchor_vote
    "news-vote-#{self.id}"
  end

  def voted_by(user)
    self.votes.where(user_id: user.id).first
  end

  def users_to_notify(user, institution)
    []
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
