class Survey < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :content_id, :questions_attributes, :lock_version

  # Scopes
  default_scope order("#{table_name}.name ASC")

  # Callbacks
  before_save :check_current_teach

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :content
  has_one :teach, through: :content
  has_many :questions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true,
    reject_if: ->(attrs) { attrs['content'].blank? }

  def to_s
    self.name
  end

  def check_current_teach
    raise 'You can not do this' unless self.content.try(:teach).try(:current?)
  end

  def self.to_csv(teach)
    CSV.generate(col_sep: ';') do |csv|
      teach.contents.each do |content|
        row = [content.to_s]

        row << content.questions.joins(survey: :content).map do |question|
          [
            "[#{question.survey}] #{question}",
            question.answers.map { |answer| [answer.to_s, answer.replies.count] }
          ]
        end

        csv << row.flatten
      end
    end
  end
end
