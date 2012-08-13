require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test 'enrollment status' do
    enrollment = Fabricate(:enrollment)
    kinship = Fabricate(:kinship, user_id: enrollment.user_id)
    Fabricate(
      :score, teach_id: enrollment.teach_id, user_id: enrollment.user_id
    )
    mail = Notifier.enrollment_status(enrollment)
    
    assert_equal I18n.t(
      'notifier.enrollment_status.subject',
      user: enrollment.user, course: enrollment.course
    ), mail.subject
    assert_equal [enrollment.user.email], mail.to
    assert_equal [kinship.relative.email], mail.cc
    assert_equal [APP_CONFIG['smtp']['user_name']], mail.from
    assert_match I18n.t(
      'notifier.enrollment_status.greeting.html',
      users: [enrollment.user.name, kinship.relative.name].to_sentence
    ), mail.body.encoded
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end

  test 'new forum' do
    institution = Fabricate(:institution)
    users = 3.times.map { Fabricate(:job, institution_id: institution.id).user }
    random_user = Fabricate(:job).user
    forum = Fabricate(
      :forum, owner_id: institution.id, owner_type: 'Institution'
    )
    mail = Notifier.new_forum(forum)

    assert_equal I18n.t('notifier.new_forum.subject', forum: forum),
      mail.subject
    assert_equal users.map(&:email).sort, mail.bcc.sort
    assert !mail.bcc.include?(random_user.email)
    assert_nil mail.to
    assert_equal [APP_CONFIG['smtp']['user_name']], mail.from
    assert_match I18n.t('notifier.new_forum.greeting.html'), mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end
  
  test 'new comment' do
    institution = Fabricate(:institution)
    users = 3.times.map { Fabricate(:job, institution_id: institution.id).user }
    random_user = Fabricate(:job).user
    forum = Fabricate(
      :forum, owner_id: institution.id, owner_type: 'Institution'
    )
    comment = Fabricate(:comment, forum_id: forum.id)
    mail = Notifier.new_comment(comment)

    assert_equal I18n.t('notifier.new_comment.subject', forum: forum),
      mail.subject
    assert_equal users.map(&:email).sort, mail.bcc.sort
    assert !mail.bcc.include?(random_user.email)
    assert_nil mail.to
    assert_equal [APP_CONFIG['smtp']['user_name']], mail.from
    assert_match I18n.t('notifier.new_comment.view'), mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end
end
