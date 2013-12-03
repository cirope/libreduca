require 'test_helper'

class DistrictTest < ActiveSupport::TestCase
  setup do
    @district = Fabricate(:district)
  end

  test 'create' do
    assert_difference 'District.count' do
      @district = District.create(Fabricate.attributes_for(:district))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'District.count' do
        assert @district.update(name: 'Updated')
      end
    end

    assert_equal 'Updated', @district.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('District.count', -1) { @district.destroy }
    end
  end

  test 'validates blank attributes' do
    @district.name = ' '

    assert @district.invalid?
    assert_equal 1, @district.errors.size
    assert_equal [error_message_from_model(@district, :name, :blank)],
      @district.errors[:name]
  end

  test 'validates unique attributes' do
    new_district = Fabricate(:district, region_id: @district.region_id)
    @district.name = new_district.name

    assert @district.invalid?
    assert_equal 1, @district.errors.size
    assert_equal [error_message_from_model(@district, :name, :taken)],
      @district.errors[:name]
  end

  test 'validates length of _long_ attributes' do
    @district.name = 'abcde' * 52

    assert @district.invalid?
    assert_equal 1, @district.errors.count
    assert_equal [
      error_message_from_model(@district, :name, :too_long, count: 255)
    ], @district.errors[:name]
  end

  test 'magick search' do
    5.times do
      Fabricate(:district) do
        name { "magick_name #{sequence(:district_name)}" }
      end
    end

    districts = District.magick_search('magick')

    assert_equal 5, districts.count
    assert districts.all? { |d| d.to_s =~ /magick/ }

    districts = District.magick_search('nodistrict')

    assert districts.empty?
  end
end
