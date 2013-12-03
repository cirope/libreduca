require 'test_helper'

class ChartControllerTest < ActionController::TestCase
  setup do
    @institution = Fabricate(:institution)
    @request.host = "#{@institution.identification}.lvh.me"
  end

  test 'should get empty index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_select '#unexpected_error', false
    assert_select '.users-row', false
    assert_template 'chart/index'
  end

  test 'should get index' do
    10.times do
      job1 = Fabricate(:job, institution_id: @institution.id)
      job2 = Fabricate(:job, institution_id: @institution.id)

      Fabricate(
        :kinship,
        user_id: job1.user_id,
        relative_id: job2.user_id,
        kin: Kinship::CHART_KINDS.sample
      )
    end

    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_select '#unexpected_error', false
    assert_select '.users-row', 1
    assert_template 'chart/index'
  end
end
