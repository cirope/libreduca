require 'test_helper'

class EnrollmentsControllerTest < ActionController::TestCase
  setup do
    sign_in Fabricate(:user)
  end

  test 'should send email summary' do
    enrollment = Fabricate(:enrollment)
    Fabricate(:kinship, user_id: enrollment.enrollable.id)

    assert_difference 'ActionMailer::Base.deliveries.size' do
      xhr :post, :send_email_summary, user_id: enrollment.enrollable, id: enrollment
    end

    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'enrollments/send_email_summary'
  end
end
