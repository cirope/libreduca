require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    @conversation = Fabricate(:conversation)
  end

  test 'create' do
    assert_difference ['Conversation.count', 'Version.count'] do
      @conversation = Conversation.create(Fabricate.attributes_for(:conversation))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Conversation.count' do
        assert @conversation.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @conversation.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Conversation.count', -1) { @conversation.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @conversation.attr = ''
    
    assert @conversation.invalid?
    assert_equal 1, @conversation.errors.size
    assert_equal [error_message_from_model(@conversation, :attr, :blank)],
      @conversation.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_conversation = Fabricate(:conversation)
    @conversation.attr = new_conversation.attr

    assert @conversation.invalid?
    assert_equal 1, @conversation.errors.size
    assert_equal [error_message_from_model(@conversation, :attr, :taken)],
      @conversation.errors[:attr]
  end
end
