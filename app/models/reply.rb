class Reply < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :answer_id, :question_id

  # Not modificable attributes
  attr_readonly :user_id

  # Callbacks
  before_update :check_age
  before_destroy -> { false }

  # Validations
  validates :answer, :question, :user, presence: true
  validates_each :question do |record, attr, value|
    if value && record.user && record.new_record?
      record.errors.add attr, :taken if value.has_been_answered_by? record.user
    end
  end

  # Relations
  belongs_to :answer
  belongs_to :question
  belongs_to :user

  def check_age
    self.created_at > 1.day.ago
  end
end