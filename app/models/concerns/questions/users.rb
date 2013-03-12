module Questions::Users
  extend ActiveSupport::Concern

  def has_been_answered_by?(user)
    self.replies.where(user_id: user.id).exists?
  end

  def reply_by(user)
    self.replies.where(user_id: user.id).first
  end
end
