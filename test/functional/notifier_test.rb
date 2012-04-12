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
end
