require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @membership = Fabricate(:membership)
  end

  test 'create' do
    assert_difference 'Membership.count' do
      @membership = Membership.create(Fabricate.attributes_for(:membership))
    end 
  end
    
  test 'update' do
    new_user = Fabricate(:user)

    assert_difference 'Version.count' do
      assert_no_difference 'Membership.count' do
        assert @membership.update_attributes(user_id: new_user.id)
      end
    end

    assert_equal new_user.id, @membership.reload.user_id
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Membership.count', -1) { @membership.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @membership.user_id = ''
    @membership.group_id = nil
    
    assert @membership.invalid?
    assert_equal 2, @membership.errors.size
    assert_equal [error_message_from_model(@membership, :user_id, :blank)],
      @membership.errors[:user_id]
    assert_equal [error_message_from_model(@membership, :group_id, :blank)],
      @membership.errors[:group_id]
  end
    
  test 'validates unique attributes' do
    new_membership = Fabricate(:membership, group_id: @membership.group_id)
    @membership.user_id = new_membership.user_id

    assert @membership.invalid?
    assert_equal 1, @membership.errors.size
    assert_equal [error_message_from_model(@membership, :user_id, :taken)],
      @membership.errors[:user_id]
  end
end
