require 'test_helper'

class KinshipTest < ActiveSupport::TestCase
  setup do
    @kinship = Fabricate(:kinship)
  end
  
  test 'create' do
    assert_difference 'Kinship.count' do
      @kinship = Kinship.create(Fabricate.attributes_for(:kinship))
    end
  end
  
  test 'update' do
    new_kin = @kinship.kin == Kinship::TYPES.first ?
      Kinship::TYPES.last : Kinship::TYPES.first
    
    assert_difference 'Version.count' do
      assert_no_difference 'Kinship.count' do
        assert @kinship.update_attributes(kin: new_kin)
      end
    end
    
    assert_equal new_kin, @kinship.reload.kin
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Kinship.count', -1) { @kinship.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @kinship.kin = ''
    
    assert @kinship.invalid?
    assert_equal 1, @kinship.errors.size
    assert_equal [error_message_from_model(@kinship, :kin, :blank)],
      @kinship.errors[:kin]
  end
  
  test 'validates included attributes' do
    @kinship.kin = 'no_kin'
    
    assert @kinship.invalid?
    assert_equal 1, @kinship.errors.size
    assert_equal [error_message_from_model(@kinship, :kin, :inclusion)],
      @kinship.errors[:kin]
  end
  
  test 'validates length of _long_ attributes' do
    @kinship.kin = 'abcde' * 52
    
    assert @kinship.invalid?
    assert_equal 2, @kinship.errors.count
    assert_equal [
      error_message_from_model(@kinship, :kin, :too_long, count: 255),
      error_message_from_model(@kinship, :kin, :inclusion)
    ].sort, @kinship.errors[:kin].sort
  end
end
