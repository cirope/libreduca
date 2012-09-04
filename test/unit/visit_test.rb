require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  setup do
    @visit = Fabricate(:visit)
  end
  
  test 'create' do
    assert_difference 'Visit.count' do
      @visit = Visit.create do |visit|
        Fabricate.attributes_for(:visit).each do |attr, value|
          visit.send "#{attr}=", value
        end
      end
    end
  end
  
  test 'update' do
    new_user = Fabricate(:user)

    assert_no_difference 'Visit.count' do
      assert @visit.update_attributes(user: new_user)
    end
    
    assert_not_equal new_user.id, @visit.reload.user_id
  end
  
  test 'no destroy' do
    # No visit can be destroyed
    assert_no_difference('Visit.count') { @visit.destroy }
  end
  
  test 'validates unique attributes' do
    new_visit = Fabricate(:visit, visited_id: @visit.visited_id)
    @visit.user_id = new_visit.user_id
    
    assert @visit.invalid?
    assert_equal 1, @visit.errors.size
    assert_equal [error_message_from_model(@visit, :user_id, :taken)],
      @visit.errors[:user_id]
  end
end
