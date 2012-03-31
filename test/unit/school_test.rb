require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def setup
    @school = Fabricate(:school)
  end
  
  test 'create' do
    assert_difference 'School.count' do
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
    @school.identification = ''
    @school.district_id = nil
    
    assert @school.invalid?
    assert_equal 3, @school.errors.size
    assert_equal [error_message_from_model(@school, :name, :blank)],
      @school.errors[:name]
    assert_equal [error_message_from_model(@school, :identification, :blank)],
      @school.errors[:identification]
    assert_equal [error_message_from_model(@school, :district_id, :blank)],
      @school.errors[:district_id]
  end
  
  test 'validates unique attributes' do
    @school.identification = Fabricate(:school).identification
    
    assert @school.invalid?
    assert_equal 1, @school.errors.size
    assert_equal [error_message_from_model(@school, :identification, :taken)],
      @school.errors[:identification]
  end
  
  test 'validates attributes are well formated' do
    @school.identification = 'xyz_'
    
    assert @school.invalid?
    assert_equal 1, @school.errors.size
    assert_equal [error_message_from_model(@school, :identification, :invalid)],
      @school.errors[:identification]
    
    @school.identification = 'xyz-'
    
    assert @school.invalid?
    assert_equal 1, @school.errors.size
    assert_equal [error_message_from_model(@school, :identification, :invalid)],
      @school.errors[:identification]
  end
  
  test 'validates length of _long_ attributes' do
    @school.name = 'abcde' * 52
    @school.identification = 'abcde' * 52
    
    assert @school.invalid?
    assert_equal 2, @school.errors.count
    assert_equal [
      error_message_from_model(@school, :name, :too_long, count: 255)
    ], @school.errors[:name]
    assert_equal [
      error_message_from_model(@school, :identification, :too_long, count: 255)
    ], @school.errors[:identification]
  end
  
  test 'magick search' do
    5.times { Fabricate(:school, name: 'magick_name') }
    3.times do
      Fabricate(:school) do
        identification {
          "magick-identification-#{sequence(:school_identification)}"
        }
      end
    end
    
    Fabricate(
      :school, name: 'magick_name', identification: 'magick-identification-10'
    )
    
    schools = School.magick_search('magick')
    
    assert_equal 9, schools.count
    assert schools.all? { |s| s.inspect =~ /magick/ }
    
    schools = School.magick_search('magick_name')
    
    assert_equal 6, schools.count
    assert schools.all? { |s| s.inspect =~ /magick_name/ }
    
    schools = School.magick_search('magick_name magick-identification')
    
    assert_equal 1, schools.count
    assert schools.all? { |s| s.inspect =~ /magick-identification.*magick_name/ }
    
    schools = School.magick_search(
      "magick_name #{I18n.t('magick_columns.or').first} magick-identification"
    )
    
    assert_equal 9, schools.count
    assert schools.all? { |s| s.inspect =~ /magick_name|magick-identification/ }
    
    schools = School.magick_search('noschool')
    
    assert schools.empty?
  end
end
