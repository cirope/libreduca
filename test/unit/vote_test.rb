require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @vote = Fabricate(:vote)
  end

  test 'create' do
    vote_attributes = Fabricate.attributes_for(:vote,
      votable_id: @vote.votable_id, votable_type: @vote.votable_type
    )

    assert_difference ['Vote.count', '@vote.votable.reload.votes_count'] do
      Vote.create do |v|
        vote_attributes.each do |attr, value|
          v.send "#{attr}=", value
        end
      end
    end
  end

  test 'destroy' do
    assert_difference ['Vote.count', '@vote.votable.reload.votes_count'], -1 do
      @vote.destroy
    end
  end

  test 'validates unique attributes' do
    new_vote = Fabricate(:vote, votable_id: @vote.votable_id)
    @vote.user_id = new_vote.user_id

    assert @vote.invalid?
    assert_equal 1, @vote.errors.size
    assert_equal [error_message_from_model(@vote, :user_id, :taken)],
      @vote.errors[:user_id]
  end
end
