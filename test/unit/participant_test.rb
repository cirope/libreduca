require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @participant = Fabricate(:participant)
  end

  test 'create' do
    assert_difference ['Participant.count', 'Version.count'] do
      @participant = Participant.create(Fabricate.attributes_for(:participant))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Participant.count' do
        assert @participant.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @participant.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Participant.count', -1) { @participant.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @participant.attr = ''
    
    assert @participant.invalid?
    assert_equal 1, @participant.errors.size
    assert_equal [error_message_from_model(@participant, :attr, :blank)],
      @participant.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_participant = Fabricate(:participant)
    @participant.attr = new_participant.attr

    assert @participant.invalid?
    assert_equal 1, @participant.errors.size
    assert_equal [error_message_from_model(@participant, :attr, :taken)],
      @participant.errors[:attr]
  end
end
