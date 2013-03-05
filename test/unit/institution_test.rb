require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase
  setup do
    @institution = Fabricate(:institution)
  end
  
  test 'create' do
    assert_difference 'Institution.count' do
      @institution = Institution.create(Fabricate.attributes_for(:institution))
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Institution.count' do
        assert @institution.update_attributes(name: 'Updated')
      end
    end
    
    assert_equal 'Updated', @institution.reload.name
  end
  
  test 'destroy' do
    assert_difference 'Version.count', 2 do
      assert_difference('Institution.count', -1) { @institution.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @institution.name = ''
    @institution.identification = ''
    @institution.district_id = nil
    
    assert @institution.invalid?
    assert_equal 3, @institution.errors.size
    assert_equal [error_message_from_model(@institution, :name, :blank)],
      @institution.errors[:name]
    assert_equal [error_message_from_model(@institution, :identification, :blank)],
      @institution.errors[:identification]
    assert_equal [error_message_from_model(@institution, :district_id, :blank)],
      @institution.errors[:district_id]
  end
  
  test 'validates unique attributes' do
    @institution.identification = Fabricate(:institution).identification
    
    assert @institution.invalid?
    assert_equal 1, @institution.errors.size
    assert_equal [error_message_from_model(@institution, :identification, :taken)],
      @institution.errors[:identification]
  end
  
  test 'validates attributes are well formated' do
    @institution.identification = 'xyz_'
    
    assert @institution.invalid?
    assert_equal 1, @institution.errors.size
    assert_equal [error_message_from_model(@institution, :identification, :invalid)],
      @institution.errors[:identification]
    
    @institution.identification = 'xyz-'
    
    assert @institution.invalid?
    assert_equal 1, @institution.errors.size
    assert_equal [error_message_from_model(@institution, :identification, :invalid)],
      @institution.errors[:identification]
  end
  
  test 'validates excluded attributes' do
    @institution.identification = RESERVED_SUBDOMAINS.first
    
    assert @institution.invalid?
    assert_equal 1, @institution.errors.size
    assert_equal [
      error_message_from_model(@institution, :identification, :exclusion)
    ], @institution.errors[:identification]
  end
  
  test 'validates length of _long_ attributes' do
    @institution.name = 'abcde' * 52
    @institution.identification = 'abcde' * 52
    
    assert @institution.invalid?
    assert_equal 2, @institution.errors.count
    assert_equal [
      error_message_from_model(@institution, :name, :too_long, count: 255)
    ], @institution.errors[:name]
    assert_equal [
      error_message_from_model(@institution, :identification, :too_long, count: 255)
    ], @institution.errors[:identification]
  end
  
  test 'magick search' do
    5.times { Fabricate(:institution, name: 'magick_name') }
    3.times do
      Fabricate(:institution) do
        identification {
          "magick-identification-#{sequence(:institution_identification)}"
        }
      end
    end
    
    Fabricate(:institution, name: 'magick_name') do
      identification { "magick-identification-#{sequence(:institution_identification)}" }
    end
    
    institutions = Institution.magick_search('magick')
    
    assert_equal 9, institutions.count
    assert institutions.all? { |s| s.inspect =~ /magick/ }
    
    institutions = Institution.magick_search('magick_name')
    
    assert_equal 6, institutions.count
    assert institutions.all? { |s| s.inspect =~ /magick_name/ }
    
    institutions = Institution.magick_search('magick_name magick-identification')
    
    assert_equal 1, institutions.count
    assert institutions.all? { |s| s.inspect =~ /magick-identification.*magick_name/ }
    
    institutions = Institution.magick_search(
      "magick_name #{I18n.t('magick_columns.or').first} magick-identification"
    )
    
    assert_equal 9, institutions.count
    assert institutions.all? { |s| s.inspect =~ /magick_name|magick-identification/ }
    
    institutions = Institution.magick_search('noinstitution')
    
    assert institutions.empty?
  end

  test 'settings' do
    assert Institution::DEFAULT_SETTINGS.size > 0

    Institution::DEFAULT_SETTINGS.each do |name, value|
      assert_equal name, @institution.send(name).name
    end

    assert_equal true, @institution.show_news.converted_value

    assert @institution.show_news.update_attributes(value: false)

    assert_equal false, @institution.reload.show_news.converted_value
  end
end
