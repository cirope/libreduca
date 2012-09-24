require 'test_helper'

class TeachTest < ActiveSupport::TestCase
  setup do
    @teach = Fabricate(:teach)
  end
  
  test 'create' do
    assert_difference 'Teach.count' do
      @teach = Teach.create(Fabricate.attributes_for(:teach))
    end
  end
  
  test 'create with enrollments' do
    course = Fabricate(:course)
    user = Fabricate(:user).tap do |u|
      Fabricate(:job, user_id: u.id, institution_id: course.institution.id)
    end
    
    assert_difference ['Teach.count', 'Enrollment.count'] do
      @teach = Teach.create(
        Fabricate.attributes_for(:teach, course_id: course.id).merge(
          enrollments_attributes: {
            new_1: Fabricate.attributes_for(
              :enrollment, user_id: user.id, teach_id: nil
            )
          }
        )
      )
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Teach.count' do
        assert @teach.update_attributes(start: Date.tomorrow)
      end
    end
    
    assert_equal Date.tomorrow, @teach.reload.start
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Teach.count', -1) { @teach.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @teach.start = ''
    @teach.finish = nil
    @teach.course_id = nil
    
    assert @teach.invalid?
    assert_equal 3, @teach.errors.size
    assert_equal [error_message_from_model(@teach, :start, :blank)],
      @teach.errors[:start]
    assert_equal [error_message_from_model(@teach, :finish, :blank)],
      @teach.errors[:finish]
    assert_equal [error_message_from_model(@teach, :course_id, :blank)],
      @teach.errors[:course_id]
  end
  
  test 'validates well formated attributes' do
    @teach.start = '13/13/13'
    @teach.finish = '13/13/13'
    
    assert @teach.invalid?
    assert_equal 4, @teach.errors.size
    assert_equal [
      error_message_from_model(@teach, :start, :blank),
      I18n.t('errors.messages.invalid_date')
    ].sort, @teach.errors[:start].sort
    assert_equal [
      error_message_from_model(@teach, :finish, :blank),
      I18n.t('errors.messages.invalid_date')
    ].sort, @teach.errors[:finish].sort
  end
  
  test 'validates attributes boundaries' do
    @teach.finish = @teach.start
    
    assert @teach.invalid?
    assert_equal 1, @teach.errors.size
    assert_equal [
      I18n.t('errors.messages.after', restriction: I18n.l(@teach.start))
    ], @teach.errors[:finish]
  end
  
  test 'current' do
    @teach.start = Date.yesterday
    
    assert @teach.valid?
    assert @teach.current?
    assert !@teach.next?
    assert !@teach.past?
  end
  
  test 'next' do
    @teach.start = Date.tomorrow
    
    assert @teach.valid?
    assert !@teach.current?
    assert @teach.next?
    assert !@teach.past?
  end
  
  test 'past' do
    @teach.start = 2.months.ago.to_date
    @teach.finish = Date.yesterday
    
    assert @teach.valid?
    assert !@teach.current?
    assert !@teach.next?
    assert @teach.past?
  end
  
  test 'enrollment for' do
    user = Fabricate(:user)
    
    enrollment = Fabricate(:enrollment, teach_id: @teach.id, user_id: user.id)
    user_2 = Fabricate(:enrollment, teach_id: @teach.id).user
    
    assert_not_nil @teach.enrollment_for(user)
    assert_equal enrollment.id, @teach.enrollment_for(user).id
    assert_not_equal enrollment.id, @teach.enrollment_for(user_2).id
  end
  
  test 'send email summary' do
    2.times do
      Fabricate(:enrollment, teach_id: @teach.id, with_job: 'student').tap do |enrollment|
        Fabricate(:kinship, user_id: enrollment.user_id)
      end
    end

    Fabricate(:enrollment, teach_id: @teach.id, with_job: 'teacher').tap do |enrollment|
      Fabricate(:kinship, user_id: enrollment.user_id)
    end
    
    # Teacher email should not be sent
    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      @teach.send_email_summary
    end
  end

  test 'next and prev content for' do
    @teach.contents.clear

    assert_equal 0, @teach.contents.count

    content = Fabricate(:content, title: 'B', teach_id: @teach.id)
    prev_content = Fabricate(:content, title: 'A', teach_id: @teach.id)
    next_content = Fabricate(:content, title: 'C', teach_id: @teach.id)

    assert_equal prev_content.id, @teach.prev_content_for(content).id
    assert_equal next_content.id, @teach.next_content_for(content).id
    assert_nil @teach.next_content_for(next_content)
    assert_nil @teach.prev_content_for(prev_content)
  end
end
