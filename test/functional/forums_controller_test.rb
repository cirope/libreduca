require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  setup do
    @forum = Fabricate(:forum)
    @owner = @forum.owner
    
    sign_in(@user = Fabricate(:user))
  end

  test 'should get index' do
    get :index, institution_id: @owner.to_param
    assert_response :success
    assert_not_nil assigns(:forums)
    assert_select '#unexpected_error', false
    assert_template 'forums/index'
  end

  test 'should get filtered index' do
    3.times do
      Fabricate(:forum, owner_id: @owner.id, owner_type: @owner.class.name) do
        name { "in_filtered_index #{sequence(:forum_name)}" }
      end
    end
    
    get :index, institution_id: @owner.to_param, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:forums)
    assert_equal 3, assigns(:forums).size
    assert assigns(:forums).all? { |g| g.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:forums).size, @owner.forums.count
    assert_select '#unexpected_error', false
    assert_template 'forums/index'
  end
 
  test 'should get new' do
    get :new, institution_id: @owner.to_param
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_select '#unexpected_error', false
    assert_template 'forums/new'
  end

  test 'should create forum' do
    assert_difference('Forum.count') do
      post :create, institution_id: @owner.to_param,
        forum: Fabricate.attributes_for(:forum).slice(
          *Forum.accessible_attributes
        )
    end

    assert_redirected_to institution_forum_url(@owner, assigns(:forum))
    assert_equal @user.id, assigns(:forum).user_id
  end

  test 'should show forum' do
    get :show, institution_id: @owner.to_param, id: @forum
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_select '#unexpected_error', false
    assert_template 'forums/show'
  end

  test 'should get edit' do
    get :edit, institution_id: @owner.to_param, id: @forum
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_select '#unexpected_error', false
    assert_template 'forums/edit'
  end

  test 'should update forum' do
    assert_no_difference 'Forum.count' do
      put :update, institution_id: @owner.to_param, id: @forum,
        forum: Fabricate.attributes_for(:forum, name: 'Upd').slice(
          *Forum.accessible_attributes
        )
    end
    
    assert_redirected_to institution_forum_url(@owner, assigns(:forum))
    assert_equal 'Upd', @forum.reload.name
  end

  test 'should destroy forum' do
    assert_difference('Forum.count', -1) do
      delete :destroy, institution_id: @owner.to_param, id: @forum
    end

    assert_redirected_to institution_forums_url(@owner)
  end

  test 'should create a comment' do
    assert_difference(['@forum.comments.count', '@user.comments.count']) do
      xhr :post, :create_comment, id: @forum, institution_id: @owner.to_param,
        comment: Fabricate.attributes_for(:comment).slice(
          *Comment.accessible_attributes
        )
    end
    
    assert_response :success
    assert_template 'forums/_comment'
  end

  test 'should not create a comment' do
    assert_no_difference(['@forum.comments.count', '@user.comments.count']) do
      xhr :post, :create_comment, id: @forum, institution_id: @owner.to_param,
        comment: Fabricate.attributes_for(:comment).slice(
          *Comment.accessible_attributes
        ).merge(comment: '')
    end
    
    assert_response :success
    assert_template 'forums/_new_comment'
  end

  test 'should get comments' do
    3.times { Fabricate(:comment, forum_id: @forum.id) }

    get :comments, id: @forum, institution_id: @owner.to_param, format: :json

    assert_response :success
    comments = ActiveSupport::JSON.decode(@response.body)

    assert_equal 3, comments.size
    assert comments.all? { |c| c['forum_id'].to_i == @forum.id }
  end
end
