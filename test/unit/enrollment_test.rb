require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  setup do
    @enrollment = Fabricate(:enrollment)
    @teach = @enrollment.teach
  end
  
  test 'create' do
    assert_difference 'Enrollment.count' do
      @enrollment = Enrollment.create(Fabricate.attributes_for(:enrollment))
    end
  end
  
  test 'update' do
    new_user = Fabricate(:user)
    
    assert_difference 'Version.count' do
      assert_no_difference 'Enrollment.count' do
        assert @enrollment.update_attributes(user_id: new_user.id)
      end
    end
    
    assert_equal new_user.id, @enrollment.reload.user_id
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Enrollment.count', -1) { @enrollment.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @enrollment.user_id = ''
    @enrollment.job = ''
    
    assert @enrollment.invalid?
    assert_equal 2, @enrollment.errors.size
    assert_equal [error_message_from_model(@enrollment, :user_id, :blank)],
      @enrollment.errors[:user_id]
    assert_equal [error_message_from_model(@enrollment, :job, :blank)],
      @enrollment.errors[:job]
  end
  
  test 'validates unique attributes' do
    new_enrollment = Fabricate(:enrollment, teach_id: @teach.id)
    @enrollment.user_id = new_enrollment.user_id
    
    assert @enrollment.invalid?
    assert_equal 1, @enrollment.errors.size
    assert_equal [error_message_from_model(@enrollment, :user_id, :taken)],
      @enrollment.errors[:user_id]
  end
  
  test 'validates included attributes' do
    @enrollment.job = 'no_job'
    
    assert @enrollment.invalid?
    assert_equal 1, @enrollment.errors.size
    assert_equal [error_message_from_model(@enrollment, :job, :inclusion)],
      @enrollment.errors[:job]
  end
  
  test 'validates length of _long_ attributes' do
    @enrollment.job = 'abcde' * 52
    
    assert @enrollment.invalid?
    assert_equal 2, @enrollment.errors.count
    assert_equal [
      error_message_from_model(@enrollment, :job, :too_long, count: 255),
      error_message_from_model(@enrollment, :job, :inclusion)
    ].sort, @enrollment.errors[:job].sort
  end
  
  test 'set job' do
    enrollment_attributes = Fabricate.attributes_for(:enrollment)
    
    @enrollment = Enrollment.new(enrollment_attributes.except('job'))
    
    assert_nil @enrollment.job
    assert @enrollment.valid? # set_job is called before validation
    assert_not_nil @enrollment.job
    assert_equal enrollment_attributes['job'], @enrollment.job
  end
  
  test 'score average' do
    common_attributes = { teach_id: @teach.id, user_id: @enrollment.user_id }
    
    Fabricate(:score, common_attributes.merge(score: '90', multiplier: '40'))
    Fabricate(:score, common_attributes.merge(score: '80', multiplier: '60'))
    Fabricate(:score, common_attributes.except(:user_id)) # Not involved
    
    assert_equal '84.00', '%.2f' % @enrollment.reload.score_average
  end
  
  test 'send email summary' do
    enrollment = Fabricate(:enrollment)
    Fabricate(:kinship, user_id: enrollment.user_id)
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      @enrollment.send_email_summary
    end
  end
  
  test 'self for user' do
    Enrollment.for_user(@enrollment.user).map(&:id).tap do |enrollment_ids|
      assert enrollment_ids.include?(@enrollment.id)
    end
    
    Fabricate(:user).tap do |new_user|
      assert Enrollment.for_user(new_user).map(&:id).exclude?(@enrollment.id)
    end
  end
  
  test 'self in school' do
    Enrollment.in_school(@teach.school).map(&:id).tap do |enrollment_ids|
      assert enrollment_ids.include?(@enrollment.id)
    end
    
    Fabricate(:school).tap do |new_school|
      assert Enrollment.in_school(new_school).map(&:id).exclude?(@enrollment.id)
    end
  end
  
  test 'self in current teach' do
    assert @enrollment.teach.start <= Date.today
    assert @enrollment.teach.finish >= Date.today
    
    Enrollment.in_current_teach.map(&:id).tap do |enrollment_ids|
      assert enrollment_ids.include?(@enrollment.id)
    end
    
    assert @enrollment.teach.update_attributes(start: Date.tomorrow)
    
    Enrollment.in_current_teach.map(&:id).tap do |enrollment_ids|
      assert enrollment_ids.exclude?(@enrollment.id)
    end
  end
end
