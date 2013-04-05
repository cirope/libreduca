require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    @conversation = Fabricate(:conversation)
  end

  test 'create' do
    assert_difference 'Conversation.count' do
      Conversation.create do |conversation|
        Fabricate.attributes_for(:conversation).each do |attr, value|
          conversation.send "#{attr}=", value
        end
      end
    end 
  end
    
  test 'can not destroy' do
    assert_no_difference ['Version.count', 'Conversation.count'] do
      @conversation.destroy
    end
  end
end 
