require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @vote = Fabricate(:vote)
  end

  test 'create' do
    assert_difference 'Vote.count' do
      @vote = Vote.create do |vote|
        Fabricate.attributes_for(:vote).each do |attr, value|
          vote.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Vote.count' do
        assert @vote.update_attributes(vote_flag: true)
      end
    end

    assert_equal true, @vote.reload.vote_flag
  end
    
  test 'no destroy' do
    # No vote can be destroyed
    assert_no_difference('Vote.count') { @vote.destroy }
  end
 
  test 'validates unique attributes' do
    new_vote = Fabricate(:vote, votable_id: @vote.votable_id)
    @vote.user_id = new_vote.user_id

    assert @vote.invalid?
    assert_equal 1, @vote.errors.size
    assert_equal [error_message_from_model(@vote, :user_id, :taken)],
      @vote.errors[:user_id]
  end

  test 'validates included attributes' do
    @vote.vote_flag = nil

    assert @vote.invalid?
    assert_equal 1, @vote.errors.size
    assert_equal [error_message_from_model(@vote, :vote_flag, :inclusion)],
      @vote.errors[:vote_flag]
  end
end
