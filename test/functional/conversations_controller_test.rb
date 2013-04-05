require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase

  setup do
    @conversation = Fabricate(:conversation)
    @institution = Fabricate(:institution) 
    @user = Fabricate(:user, password: '123456', role: :normal)
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: @institution.id, job: 'teacher'
    )
    @request.host = "#{@institution.identification}.lvh.me"

    sign_in @user
  end

  test "should get new" do
    presentation = Fabricate(:presentation)

    get :new, presentation_id: presentation.id
    assert_response :success
    assert_not_nil assigns(:conversation)
    assert_select '#unexpected_error', false
    assert_template "conversations/new"
  end

  test "should create conversation" do
    presentation = Fabricate(:presentation)
  
    assert_difference ['Conversation.count', 'Comment.count'] do
      post :create, presentation_id: presentation.id, 
        conversation: { 
          comments_attributes: { 
            comment_1: { comment: Faker::Lorem.sentences(4).join("\n") }
          }
        }, format: :js
    end

    assert_response :success
    assert_not_nil assigns(:conversation) 
  end

  test "should show conversation" do
    get :show, id: @conversation, presentation_id: @conversation.conversable_id
    assert_response :success
    assert_not_nil assigns(:conversation)
    assert_select '#unexpected_error', false
    assert_template "conversations/show"
  end
end
