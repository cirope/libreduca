require 'test_helper'

class SurveysControllerTest < ActionController::TestCase

  setup do
    @survey = Fabricate(:survey)
    @teach = @survey.teach
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index, teach_id: @teach
    assert_response :success
    assert_not_nil assigns(:surveys)
    assert_select '#unexpected_error', false
    assert_template 'surveys/index'
  end

  test 'should get index in csv' do
    get :index, teach_id: @teach, format: :csv
    assert_response :success
    assert_not_nil assigns(:surveys)

    assert CSV.parse(@response.body).size > 0
  end

  test 'should get new' do
    get :new, teach_id: @teach
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/new'
  end

  test 'should create survey' do
    assert_difference('Survey.count') do
      post :create, teach_id: @teach, survey: 
        Fabricate.attributes_for(:survey, teach_id: nil).slice(
          *Survey.accessible_attributes
        )
    end

    assert_redirected_to teach_survey_url(@teach, assigns(:survey))
  end

  test 'should show survey' do
    get :show, teach_id: @teach, id: @survey
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/show'
  end

  test 'should get edit' do
    get :edit, teach_id: @teach, id: @survey
    assert_response :success
    assert_not_nil assigns(:survey)
    assert_select '#unexpected_error', false
    assert_template 'surveys/edit'
  end

  test 'should update survey' do
    put :update, teach_id: @teach, id: @survey, survey:
      Fabricate.attributes_for(:survey, teach_id: nil, attr: 'value').slice(
        *Survey.accessible_attributes
      )
    assert_redirected_to teach_survey_url(@teach, assigns(:survey))
  end

  test 'should destroy survey' do
    assert_difference('Survey.count', -1) do
      delete :destroy, id: @survey, teach_id: @teach
    end

    assert_redirected_to teach_surveys_url(@teach)
  end
end
