module Contents::Surveys
  extend ActiveSupport::Concern

  included do
    has_many :surveys, dependent: :destroy
    has_many :questions, through: :surveys
    has_many :answers, through: :questions
    has_many :replies, through: :answers
  end
end
