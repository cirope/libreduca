class NewForumNotifierWorker
  include Sidekiq::Worker

  def perform(forum_id)
    forum = Forum.find forum_id

    Notifier.new_forum(forum).deliver
  end
end
