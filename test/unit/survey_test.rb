require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  setup do
    @survey = Fabricate(:survey)
  end
  
  test 'create' do
    assert_difference 'Survey.count' do
      @survey = Survey.create do |survey|
        Fabricate.attributes_for(:survey).each do |attr, value|
          survey.send "#{attr}=", value
        end
      end
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Survey.count' do
        assert @survey.update_attributes(name: 'Updated')
      end
    end
    
    assert_equal 'Updated', @survey.reload.name
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Survey.count', -1) { @survey.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @survey.name = ''
    
    assert @survey.invalid?
    assert_equal 1, @survey.errors.size
    assert_equal [error_message_from_model(@survey, :name, :blank)],
      @survey.errors[:name]
  end

  test 'validates length of _long_ attributes' do
    @survey.name = 'abcde' * 52
    
    assert @survey.invalid?
    assert_equal 1, @survey.errors.count
    assert_equal [
      error_message_from_model(@survey, :name, :too_long, count: 255)
    ], @survey.errors[:name]
  end
end
