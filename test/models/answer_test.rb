require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  setup do
    @answer = Fabricate(:answer)
  end

  test 'create' do
    assert_difference 'Answer.count' do
      @answer = Answer.create do |answer|
        Fabricate.attributes_for(:answer).each do |attr, value|
          answer.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Answer.count' do
        assert @answer.update(content: 'Updated')
      end
    end

    assert_equal 'Updated', @answer.reload.content
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Answer.count', -1) { @answer.destroy }
    end
  end

  test 'validates blank attributes' do
    @answer.content = ''

    assert @answer.invalid?
    assert_equal 1, @answer.errors.size
    assert_equal [error_message_from_model(@answer, :content, :blank)],
      @answer.errors[:content]
  end

  test 'validates length of _long_ attributes' do
    @answer.content = 'abcde' * 52

    assert @answer.invalid?
    assert_equal 1, @answer.errors.count
    assert_equal [
      error_message_from_model(@answer, :content, :too_long, count: 255)
    ], @answer.errors[:content]
  end
end
