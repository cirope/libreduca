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

    assert_difference('Vote.positives.count') do
      post :create, comment_id: comment.to_param, vote_flag: 'positive'
    end

    assert_redirected_to comment_vote_url(comment, assigns(:vote))
  end

  test "should show vote" do
    get :show, comment_id: @comment.to_param, id: @vote
    assert_response :success
    assert_not_nil assigns(:vote)
    assert_select '#unexpected_error', false
    assert_template "votes/show"
  end

  test "should update vote" do
    assert_no_difference 'Vote.count' do
      put :update, id: @vote, comment_id: @comment.id, vote_flag: 'positive'
    end

    assert_redirected_to comment_vote_url(@comment, assigns(:vote))
  end
end
