require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  setup do
    institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'teacher'
    )
    @commentable_forum = Fabricate(
      :forum, owner_id: institution.id, owner_type: institution.class.name
    )
    @commentable_news = Fabricate(:news, institution_id: institution.id)
    @comment = Fabricate(
      :comment, commentable_id: @commentable_forum.id, commentable_type: @commentable_forum.class.name
    )
    @comment_news = Fabricate(
      :comment, commentable_id: @commentable_news.id, commentable_type: @commentable_news.class.name
    )
    @request.host = "#{institution.identification}.lvh.me"
    
    sign_in @user
  end

  test 'should get index forum comment' do
    get :index, forum_id: @commentable_forum.to_param
    assert_response :success
    assert_not_nil assigns(:comments)
    assert_select '#unexpected_error', false
    assert_template 'comments/index'
  end

  test 'should get index news comment' do
    get :index, news_id: @commentable_news.to_param
    assert_response :success
    assert_not_nil assigns(:comments)
    assert_select '#unexpected_error', false
    assert_template 'comments/index'
  end

  test 'should get new forum comment' do
    get :new, forum_id: @commentable_forum.to_param
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/new'
  end

  test 'should get new news comment' do
    get :new, news_id: @commentable_news.to_param
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/new'
  end

  test 'should create forum comment' do
    3.times.map { Fabricate(:job, institution_id: @commentable_forum.owner_id) }
    counts = ['@commentable_forum.comments.count', 'ActionMailer::Base.deliveries.size']

    assert_difference counts do
      post :create, forum_id: @commentable_forum.to_param,
        comment: Fabricate.attributes_for(:comment_forum).slice(
          *Comment.accessible_attributes
        )
    end

    assert_redirected_to [@commentable_forum, assigns(:comment)]
  end

  test 'should create forum comment as student' do
    assert @job.update_attribute :job, 'student'

    assert_difference('@commentable_forum.comments.count') do
      assert_no_difference 'ActionMailer::Base.deliveries.size'    do
        post :create, forum_id: @commentable_forum.to_param,
          comment: Fabricate.attributes_for(:comment).slice(
            *Comment.accessible_attributes
          )
      end
    end

    assert_redirected_to [@commentable_forum, assigns(:comment)]
  end

  test 'should create news comment as student' do
    assert @job.update_attribute :job, 'student'

    assert_difference('@commentable_news.comments.count') do
      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        post :create, news_id: @commentable_news.to_param,
          comment: Fabricate.attributes_for(:comment).slice(
            *Comment.accessible_attributes
          )
      end
    end

    assert_redirected_to [@commentable_news, assigns(:comment)]
  end

  test 'should show forum comment' do
    get :show, forum_id: @commentable_forum.to_param, id: @comment
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_select '#unexpected_error', false
    assert_template 'comments/show'
  end
end
