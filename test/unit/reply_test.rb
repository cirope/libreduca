require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  setup do
    @reply = Fabricate(:reply)
  end
  
  test 'create' do
    assert_difference 'Reply.count' do
      @reply = Reply.create do |reply|
        Fabricate.attributes_for(:reply).each do |attr, value|
          reply.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    old_answer_id = @reply.answer_id
    new_answer_id = Fabricate(:answer, question_id: @reply.question_id).id

    assert_no_difference 'Reply.count' do
      assert @reply.update_attributes(answer_id: new_answer_id), @reply.errors.full_messages.join('; ')
    end

    assert_not_equal old_answer_id, @reply.reload.answer_id
    assert_equal new_answer_id, @reply.reload.answer_id
  end
  
  test 'can not destroy' do
    assert_no_difference ['Version.count', 'Reply.count'] do
      @reply.destroy
    end
  end
  
  test 'validates blank attributes' do
    @reply.question_id = nil
    @reply.answer_id = nil
    @reply.user = nil
    
    assert @reply.invalid?
    assert_equal 5, @reply.errors.size
    assert_equal [error_message_from_model(@reply, :user, :blank)],
      @reply.errors[:user]
    assert_equal [error_message_from_model(@reply, :question, :blank)],
      @reply.errors[:question]
    assert_equal [error_message_from_model(@reply, :answer, :blank)],
      @reply.errors[:answer]
    assert_equal [error_message_from_model(@reply, :response, :blank)],
      @reply.errors[:response]
    assert_equal [error_message_from_model(@reply, :base, :invalid_answer)],
      @reply.errors[:base]
  end

  test 'validates unique attributes' do
    new_reply = Fabricate.build(
      :reply,
      user_id: @reply.user_id,
      question_id: @reply.question_id,
      answer_id: @reply.answer_id
    )

    assert new_reply.invalid?
    assert_equal 1, new_reply.errors.size
    assert_equal [error_message_from_model(new_reply, :question, :taken)],
      new_reply.errors[:question]
  end

  test 'validates reply consistency' do
    @reply.response = 'Some content'

    assert @reply.invalid?
    assert_equal 1, @reply.errors.count
    assert_equal [error_message_from_model(@reply, :base, :invalid_answer)],
      @reply.errors[:base]

    @reply.answer = nil
    assert_valid @reply
  end
end
