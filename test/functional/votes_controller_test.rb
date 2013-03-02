require 'test_helper'

class VotesControllerTest < ActionController::TestCase

  setup do
    institution = Fabricate(:institution)

    @vote = Fabricate(:vote)
    @comment = @vote.votable
    @user = @vote.user

    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user
  end

  test "should create vote" do
    comment = Fabricate(:comment_news, user_id: @user.id)

    assert_difference ['Vote.count', 'comment.reload.votes_count'] do
      post :create, comment_id: comment.to_param, format: 'js'
    end

    assert_response :success
  end

  test 'should destroy vote' do

    assert_difference ['Vote.count', '@vote.votable.reload.votes_count'], -1 do
      delete :destroy, id: @vote.id, comment_id: @comment.to_param, format: 'js'
    end

    assert_response :success
  end
end
