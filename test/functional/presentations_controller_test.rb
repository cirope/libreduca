require 'test_helper'

class PresentationsControllerTest < ActionController::TestCase
  setup do
    @presentation = Fabricate(:presentation)
    @content = @presentation.content
    @homework = @presentation.homework
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get index' do
    get :index, content_id: @content, homework_id: @homework
    assert_response :success
    assert_not_nil assigns(:presentations)
    assert_select '#unexpected_error', false
    assert_template 'presentations/index'
  end

  test 'should get new' do
    get :new, content_id: @content, homework_id: @homework
    assert_response :success
    assert_not_nil assigns(:presentation)
    assert_select '#unexpected_error', false
    assert_template 'presentations/new'
  end

  test 'should create presentation' do
    homework = Fabricate(:homework)

    assert_difference('Presentation.count') do
      post :create, content_id: homework.content, homework_id: homework,
        presentation: Fabricate.attributes_for(
          :presentation, user_id: nil, homework_id: nil
        ).slice(*Presentation.accessible_attributes)
    end

    assert_redirected_to teach_content_url(homework.content.teach, homework.content)
  end

  test 'should create presentation with response in js' do
    homework = Fabricate(:homework)

    assert_difference('Presentation.count') do
      post :create, format: :js, content_id: homework.content, homework_id: homework,
        presentation: Fabricate.attributes_for(
          :presentation, user_id: nil, homework_id: nil
        ).slice(*Presentation.accessible_attributes)
    end

    assert_template 'presentations/create'
  end


  test 'should show presentation' do
    get :show, content_id: @content, homework_id: @homework, id: @presentation
    assert_response :success
    assert_not_nil assigns(:presentation)
    assert_select '#unexpected_error', false
    assert_template 'presentations/show'
  end

  test 'should destroy presentation' do
    assert_difference('Presentation.count', -1) do
      delete :destroy, content_id: @content, homework_id: @homework,
        id: @presentation
    end

    assert_redirected_to teach_content_url(@content.teach, @content)
  end
end
