class NewCommentNotifierWorker
  include Sidekiq::Worker

  def perform(comment_id)
    comment = Comment.find comment_id

    Notifier.new_comment(comment).deliver
  end
end
