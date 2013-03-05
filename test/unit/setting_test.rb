require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    @setting = Fabricate(:setting)
    @configurable = @setting.configurable
  end

  test 'create' do
    assert_difference ['Setting.count', '@configurable.settings.count'] do
      @setting = @configurable.settings.create(
        Fabricate.attributes_for(:setting, configurable_id: nil).slice(
          *Setting.accessible_attributes
        )
      )
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Setting.count' do
        assert @setting.update_attributes(value: 'Updated')
      end
    end

    assert_equal 'Updated', @setting.reload.value
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Setting.count', -1) { @setting.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @setting.name = ''
    @setting.kind = ''
    
    assert @setting.invalid?
    assert_equal 3, @setting.errors.size
    assert_equal [error_message_from_model(@setting, :name, :blank)],
      @setting.errors[:name]
    assert_equal [
      error_message_from_model(@setting, :kind, :blank),
      error_message_from_model(@setting, :kind, :inclusion)
    ].sort, @setting.errors[:kind].sort
  end

  test 'validates attributes lenght' do
    @setting.name = 'abcde' * 52
    @setting.kind = 'abcde' * 52

    assert @setting.invalid?
    assert_equal 3, @setting.errors.size
    assert_equal [
      error_message_from_model(@setting, :name, :too_long, count: 255)
    ], @setting.errors[:name]
    assert_equal [
      error_message_from_model(@setting, :kind, :too_long, count: 255),
      error_message_from_model(@setting, :kind, :inclusion)
    ].sort, @setting.errors[:kind].sort
  end
  
  test 'validates included attributes' do
    @setting.kind = 'wrong'

    assert @setting.invalid?
    assert_equal 1, @setting.errors.size
    assert_equal [error_message_from_model(@setting, :kind, :inclusion)],
      @setting.errors[:kind]
  end
end
