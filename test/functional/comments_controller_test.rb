require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  setup do
    institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'teacher'
    )
    @commentable = Fabricate(
      :forum, owner_id: institution.id, owner_type: institution.class.name
    )
    @comment = Fabricate(
      :comment, commentable_id: @commentable.id, commentable_type: @commentable.class.name
    )
    @request.host = "#{institution.identification}.lvh.me"
    
    sign_in @user
  end

  test 'should get index' do
    get :index, forum_id: @commentable.to_param
    assert_response :success
    assert_not_nil assigns(:comments)
    assert_select '#unexpected_error', false
    assert_template 'comments/index'
  end

  test 'should get new' do
    get :new, forum_id: @commentable.to_param
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/new'
  end

  test 'should create comment' do
    counts = ['@commentable.comments.count', 'ActionMailer::Base.deliveries.size']

    assert_difference counts do
      post :create, forum_id: @commentable.to_param,
        comment: Fabricate.attributes_for(:comment).slice(
          *Comment.accessible_attributes
        )
    end

    assert_redirected_to [@commentable, assigns(:comment)]
  end
  
  test 'should create comment as student' do
    assert @job.update_attribute :job, 'student'

    assert_difference('@commentable.comments.count') do
      assert_no_difference 'ActionMailer::Base.deliveries.size'    do
        post :create, forum_id: @commentable.to_param,
          comment: Fabricate.attributes_for(:comment).slice(
            *Comment.accessible_attributes
          )
      end
    end

    assert_redirected_to [@commentable, assigns(:comment)]
  end


  test 'should show comment' do
    get :show, forum_id: @commentable.to_param, id: @comment
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/show'
  end

  test 'should get edit' do
    get :edit, forum_id: @commentable.to_param, id: @comment
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/edit'
  end

  test 'should update comment' do
    put :update, forum_id: @commentable.to_param, id: @comment, 
      comment: { comment: 'Updated' }
    
    assert_equal 'Updated', @comment.reload.comment
    assert_redirected_to [@commentable, assigns(:comment)]
  end

  test 'should destroy comment' do
    assert_difference('Comment.count', -1) do
      delete :destroy, forum_id: @commentable.to_param, id: @comment
    end

    assert_redirected_to [@commentable, Comment]
  end
end
