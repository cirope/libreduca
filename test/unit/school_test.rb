require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def setup
    @school = Fabricate(:school)
  end
  
  test 'create' do
    assert_difference ['School.count', 'Version.count'] do
      @school = School.create(Fabricate.attributes_for(:school))
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'School.count' do
        assert @school.update_attributes(name: 'Updated')
      end
    end
    
    assert_equal 'Updated', @school.reload.name
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('School.count', -1) { @school.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @school.name = ''
    
    assert @school.invalid?
    assert_equal 1, @school.errors.size
    assert_equal [error_message_from_model(@school, :name, :blank)],
      @school.errors[:name]
  end
  
  test 'validates length of _long_ attributes' do
    @school.name = 'abcde' * 52
    
    assert @school.invalid?
    assert_equal 1, @school.errors.count
    assert_equal [
      error_message_from_model(@school, :name, :too_long, count: 255)
    ], @school.errors[:name]
  end
  
  test 'magick search' do
    5.times { Fabricate(:school, name: 'magick_name') }
    3.times { Fabricate(:school, identification: 'magick_identification') }
    
    Fabricate(
      :school, name: 'magick_name', identification: 'magick_identification'
    )
    
    schools = School.magick_search('magick')
    
    assert_equal 9, schools.count
    assert schools.all? { |s| s.to_s =~ /magick/ }
    
    schools = School.magick_search('magick_name')
    
    assert_equal 6, schools.count
    assert schools.all? { |s| s.to_s =~ /magick_name/ }
    
    schools = School.magick_search('magick_name magick_identification')
    
    assert_equal 1, schools.count
    assert schools.all? { |s| s.to_s =~ /magick_identification.*magick_name/ }
    
    schools = School.magick_search(
      "magick_name #{I18n.t('magick_columns.or').first} magick_identification"
    )
    
    assert_equal 9, schools.count
    assert schools.all? { |s| s.to_s =~ /magick_name|magick_identification/ }
    
    schools = School.magick_search('nobody')
    
    assert schools.empty?
  end
end
