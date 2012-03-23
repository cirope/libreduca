require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  def setup
    @region = Fabricate(:region)
  end
  
  test 'create' do
    assert_difference ['Region.count', 'Version.count'] do
      @region = Region.create(Fabricate.attributes_for(:region))
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Region.count' do
        assert @region.update_attributes(name: 'Updated')
      end
    end
    
    assert_equal 'Updated', @region.reload.name
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Region.count', -1) { @region.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @region.name = ''
    
    assert @region.invalid?
    assert_equal 1, @region.errors.size
    assert_equal [error_message_from_model(@region, :name, :blank)],
      @region.errors[:name]
  end
  
  test 'validates unique attributes' do
    new_region = Fabricate(:region)
    @region.name = new_region.name
    
    assert @region.invalid?
    assert_equal 1, @region.errors.size
    assert_equal [error_message_from_model(@region, :name, :taken)],
      @region.errors[:name]
  end
  
  test 'validates length of _long_ attributes' do
    @region.name = 'abcde' * 52
    
    assert @region.invalid?
    assert_equal 1, @region.errors.count
    assert_equal [
      error_message_from_model(@region, :name, :too_long, count: 255)
    ], @region.errors[:name]
  end
  
  test 'magick search' do
    5.times do
      Fabricate(:region) { name { "magick_name #{sequence(:region_name)}" } }
    end
    
    regions = Region.magick_search('magick')
    
    assert_equal 5, regions.count
    assert regions.all? { |s| s.to_s =~ /magick/ }
    
    regions = Region.magick_search('noplace')
    
    assert regions.empty?
  end
end
