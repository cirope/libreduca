require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  setup do
    institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'teacher'
    )
    @forum = Fabricate(
      :forum, owner_id: institution.id, owner_type: institution.class.name
    )
    @owner = @forum.owner
    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user
  end

  test 'should get index' do
    get :index, institution_id: @owner.to_param
    assert_response :success
    assert_not_nil assigns(:forums)
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
    assert_template 'forums/index'
  end

  test 'should get new' do
    get :new, institution_id: @owner.to_param
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_template 'forums/new'
  end

  test 'should create forum' do
    assert_difference(['Forum.count', 'ActionMailer::Base.deliveries.size']) do
      post :create, institution_id: @owner.to_param,
        forum: Fabricate.attributes_for(:forum)
    end

    assert_redirected_to institution_forum_url(@owner, assigns(:forum))
    assert_equal @user.id, assigns(:forum).user_id
  end

  test 'should show forum' do
    get :show, institution_id: @owner.to_param, id: @forum
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_template 'forums/show'
  end

  test 'should get edit' do
    get :edit, institution_id: @owner.to_param, id: @forum
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_template 'forums/edit'
  end

  test 'should update forum' do
    assert_no_difference 'Forum.count' do
      patch :update, institution_id: @owner.to_param, id: @forum,
        forum: Fabricate.attributes_for(:forum, name: 'Upd')
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
end
