require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @participant = Fabricate(:participant)
  end

  test 'create' do
    assert_difference 'Participant.count' do
      Participant.create do |participant|
        Fabricate.attributes_for(:participant).each do |attr, value|
          participant.send "#{attr}=", value
        end
      end
    end
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Participant.count', -1) { @participant.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @participant.user = nil
    @participant.conversation = nil
    
    assert @participant.invalid?
    assert_equal 2, @participant.errors.size
    assert_equal [error_message_from_model(@participant, :user, :blank)],
      @participant.errors[:user]
    assert_equal [error_message_from_model(@participant, :conversation, :blank)],
      @participant.errors[:conversation]
  end
end
