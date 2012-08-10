require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  setup do
    @grade = Fabricate(:grade)
    @school = @grade.school
  end
  
  test 'create' do
    assert_difference 'Grade.count' do
      @grade = Grade.create(Fabricate.attributes_for(:grade))
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Grade.count' do
        assert @grade.update_attributes(name: 'Updated')
      end
    end
    
    assert_equal 'Updated', @grade.reload.name
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Grade.count', -1) { @grade.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @grade.name = ''
    @grade.school_id = nil
    
    assert @grade.invalid?
    assert_equal 2, @grade.errors.size
    assert_equal [error_message_from_model(@grade, :name, :blank)],
      @grade.errors[:name]
    assert_equal [error_message_from_model(@grade, :school_id, :blank)],
      @grade.errors[:school_id]
  end
  
  test 'validates unique attributes' do
    new_grade = Fabricate(:grade, school_id: @school.id)
    @grade.name = new_grade.name
    
    assert @grade.invalid?
    assert_equal 1, @grade.errors.size
    assert_equal [error_message_from_model(@grade, :name, :taken)],
      @grade.errors[:name]
  end
  
  test 'validates length of _long_ attributes' do
    @grade.name = 'abcde' * 52
    
    assert @grade.invalid?
    assert_equal 1, @grade.errors.count
    assert_equal [
      error_message_from_model(@grade, :name, :too_long, count: 255)
    ], @grade.errors[:name]
  end
  
  test 'magick search' do
    5.times do
      Fabricate(:grade) { name { "magick_name #{sequence(:grade_name)}" } }
    end
    
    grades = Grade.magick_search('magick')
    
    assert_equal 5, grades.count
    assert grades.all? { |s| s.to_s =~ /magick/ }
    
    grades = Grade.magick_search('noplace')
    
    assert grades.empty?
  end
end
