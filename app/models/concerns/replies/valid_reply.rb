module Replies::ValidReply
  extend ActiveSupport::Concern

  included do
    validates :answer, presence: true, if: ->(r) { r.response.blank? }
    validates :response, presence: true, if: ->(r) { r.answer.blank? }

    validate :answer_or_response
  end

  def answer_or_response
    unless self.answer.present? ^ self.response.present?
      self.errors.add :base, :invalid_answer
    end
  end
end
