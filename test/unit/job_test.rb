require 'test_helper'

class JobTest < ActiveSupport::TestCase
  setup do
    @job = Fabricate(:job)
  end
  
  test 'create' do
    assert_difference 'Job.count' do
      @job = Job.create(Fabricate.attributes_for(:job))
    end
  end
  
  test 'update' do
    new_job = @job.job == Job::TYPES.first ? Job::TYPES.last : Job::TYPES.first
    
    assert_difference 'Version.count' do
      assert_no_difference 'Job.count' do
        assert @job.update_attributes(job: new_job)
      end
    end
    
    assert_equal new_job, @job.reload.job
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Job.count', -1) { @job.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @job.job = ''
    
    assert @job.invalid?
    assert_equal 1, @job.errors.size
    assert_equal [error_message_from_model(@job, :job, :blank)],
      @job.errors[:job]
  end
  
  test 'validates included attributes' do
    @job.job = 'no_job'
    
    assert @job.invalid?
    assert_equal 1, @job.errors.size
    assert_equal [error_message_from_model(@job, :job, :inclusion)],
      @job.errors[:job]
  end
  
  test 'validates length of _long_ attributes' do
    @job.job = 'abcde' * 52
    
    assert @job.invalid?
    assert_equal 2, @job.errors.count
    assert_equal [
      error_message_from_model(@job, :job, :too_long, count: 255),
      error_message_from_model(@job, :job, :inclusion)
    ].sort, @job.errors[:job].sort
  end

  test 'job type methods' do
    Job::TYPES.each do |type|
      @job.job = type
      assert @job.send("#{type}?")

      (Job::TYPES - [type]).each do |wrong_type|
        @job.job = wrong_type

        assert !@job.send("#{type}?")
      end
    end
  end
end
