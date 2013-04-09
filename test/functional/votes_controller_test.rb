require 'test_helper'

class VotesControllerTest < ActionController::TestCase

  setup do
    @institution = Fabricate(:institution)

    news = Fabricate(:news, institution_id: @institution.id)
    @comment = Fabricate(
      :comment, commentable_id: news.id, commentable_type: news.class.model_name
    )
    @vote = Fabricate(:vote, votable_id: @comment.id, votable_type: @comment.class.model_name)
    @user = @comment.user

    @request.host = "#{@institution.identification}.lvh.me"

    sign_in @user
  end

  test "should create vote" do

    assert_difference ['Vote.count', '@comment.reload.votes_count'] do
      post :create, comment_id: @comment.to_param, format: 'js'
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
