require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  setup do
    @survey = Fabricate(:survey)
    @teach = @survey.teach
    @content = @survey.content
    @user = Fabricate(:user)

    sign_in @user
  end

  test 'should get teach index' do
    get :index, teach_id: @teach
    assert_response :success
    assert_not_nil assigns(:surveys)
    assert_not_nil assigns(:teach)
    assert_select '#unexpected_error', false
    assert_template 'surveys/index'
  end

  test 'should get content index' do
    get :index, content_id: @content
    assert_response :success
    assert_not_nil assigns(:surveys)
    assert_not_nil assigns(:content)
    assert_select '#unexpected_error', false
    assert_template 'surveys/index'
  end

  test 'should get teach index in csv' do
    get :index, teach_id: @teach, format: :csv
    assert_response :success
    assert_not_nil assigns(:surveys)

    assert CSV.parse(@response.body).size > 0
  end

  test 'should get new' do
    get :new, content_id: @content
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/new'
  end

  test 'should create survey' do
    assert_difference('Survey.count') do
      post :create, content_id: @content, survey: 
        Fabricate.attributes_for(:survey, content_id: nil).slice(
          *Survey.accessible_attributes
        )
    end

    assert_redirected_to content_survey_url(@content, assigns(:survey))
  end

  test 'should show survey' do
    get :show, content_id: @content, id: @survey
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/show'
  end

  test 'should show survey in csv' do
    get :show, content_id: @content, id: @survey, format: :csv
    assert_response :success
    assert_not_nil assigns(:survey)

    assert CSV.parse(@response.body).size > 0
  end

  test 'should get edit' do
    get :edit, content_id: @content, id: @survey
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/edit'
  end

  test 'should update survey' do
    put :update, content_id: @content, id: @survey, survey:
      Fabricate.attributes_for(:survey, content_id: nil, attr: 'value').slice(
        *[Survey.accessible_attributes.to_a - ['content_id']]
      )

    assert_redirected_to content_survey_url(@content, assigns(:survey))
  end

  test 'should destroy survey' do
    assert_difference('Survey.count', -1) do
      delete :destroy, id: @survey, content_id: @content
    end

    assert_redirected_to content_surveys_url(@content)
  end
end
