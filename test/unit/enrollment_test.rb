require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  def setup
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
end
