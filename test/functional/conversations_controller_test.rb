require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase

  setup do
    @conversation = Fabricate(:conversation)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conversations)
    assert_select '#unexpected_error', false
    assert_template "conversations/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:conversation)
    assert_select '#unexpected_error', false
    assert_template "conversations/new"
  end

  test "should create conversation" do
    assert_difference('Conversation.count') do
      post :create, conversation: Fabricate.attributes_for(:conversation)
    end

    assert_redirected_to conversation_url(assigns(:conversation))
  end

  test "should show conversation" do
    get :show, id: @conversation
    assert_response :success
    assert_not_nil assigns(:conversation)
    assert_select '#unexpected_error', false
    assert_template "conversations/show"
  end

  test "should get edit" do
    get :edit, id: @conversation
    assert_response :success
    assert_not_nil assigns(:conversation)
    assert_select '#unexpected_error', false
    assert_template "conversations/edit"
  end

  test "should update conversation" do
    put :update, id: @conversation, 
      conversation: Fabricate.attributes_for(:conversation, attr: 'value')
    assert_redirected_to conversation_url(assigns(:conversation))
  end

  test "should destroy conversation" do
    assert_difference('Conversation.count', -1) do
      delete :destroy, id: @conversation
    end

    assert_redirected_to conversations_path
  end
end
