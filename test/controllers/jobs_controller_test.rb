require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
  end

  test 'should create existing user in a new institution' do
    institution = login_into_institution

    another_user = Fabricate(:user)

    assert_difference('Job.count') do
      post :create, user_id: another_user.to_param,
        job: Fabricate.attributes_for(:job, institution_id: institution.id, user_id: another_user.id)
    end

    assert_response :redirect
    assert_redirected_to user_url(assigns(:user))
  end

  private

  def login_into_institution
    institution = Fabricate(:institution)

    Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'janitor'
    )

    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user
    institution
  end
end