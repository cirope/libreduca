require 'test_helper'

class RepliesControllerTest < ActionController::TestCase
  setup do
    @reply = Fabricate(:reply)
    @question = @reply.question

    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index, question_id: @question
    assert_response :success
    assert_not_nil assigns(:replies)
    assert_select '#unexpected_error', false
    assert_template 'replies/index'
  end
  
  test 'should get new' do
    get :new, question_id: @question
    assert_response :success
    assert_not_nil assigns(:reply)
    assert_select '#unexpected_error', false, @response.body
    assert_template 'replies/new'
  end

  test 'should create reply' do
    assert_difference('Reply.count') do
      post :create, question_id: @question,
        reply: Fabricate.attributes_for(:reply).slice(
          *Reply.accessible_attributes
        )
    end

    assert_redirected_to question_reply_url(@question, assigns(:reply))
  end

  test 'should show reply' do
    get :show, id: @reply, question_id: @question
    assert_response :success
    assert_not_nil assigns(:reply)
    assert_select '#unexpected_error', false
    assert_template 'replies/show'
  end

  test 'should get edit' do
    get :edit, id: @reply, question_id: @question
    assert_response :success
    assert_not_nil assigns(:reply)
    assert_select '#unexpected_error', false, @response.body
    assert_template 'replies/edit'
  end

  test 'should update reply' do
    new_question = Fabricate(:question)
    
    assert_no_difference 'Reply.count' do
      put :update, id: @reply, question_id: @question,
        reply: { question_id: new_question.id }
    end
    
    assert_redirected_to question_reply_url(@question, assigns(:reply))
    assert_equal new_question.id, @reply.reload.question_id
  end
end
