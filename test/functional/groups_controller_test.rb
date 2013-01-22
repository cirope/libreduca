require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  setup do
    @institution = Fabricate(:institution)
    @group = Fabricate(:group, institution_id: @institution.id)
    @user = Fabricate(:user)
    @job = Fabricate(:job, institution_id: @institution.id, user_id: @user.id)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
    assert_select '#unexpected_error', false
    assert_template "groups/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:group)
    assert_select '#unexpected_error', false
    assert_template "groups/new"
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: Fabricate.attributes_for(:group).slice(
        *Group.accessible_attributes
      ).merge(
        memberships_attributes: 1.times.map {
          Fabricate.attributes_for(
            :membership, user_id: @user.id, group_id: @group.id
          ).slice(*Membership.accessible_attributes)
        }
      )
    end

    assert_redirected_to group_url(assigns(:group))
  end

  test "should show group" do
    get :show, id: @group
    assert_response :success
    assert_not_nil assigns(:group)
    assert_select '#unexpected_error', false
    assert_template "groups/show"
  end

  test "should get edit" do
    get :edit, id: @group
    assert_response :success
    assert_not_nil assigns(:group)
    assert_select '#unexpected_error', false
    assert_template "groups/edit"
  end

  test "should update group" do
    put :update, id: @group,
      group: Fabricate.attributes_for(:group)
    assert_redirected_to group_url(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group
    end

    assert_redirected_to groups_path
  end
end
