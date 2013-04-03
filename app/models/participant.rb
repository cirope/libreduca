class Participant < ActiveRecord::Base
  has_paper_trail

  attr_accessible :user

  # Relations
  belongs_to :user
  belongs_to :conversation

  # Validations
  validates :user, :conversation, presence: true
end
