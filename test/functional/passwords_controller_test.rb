require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

  setup do
    @institution = Fabricate(:institution)
    @user = Fabricate(:user)

    @job = Fabricate(
      :job, user_id: @user.id, institution_id: @institution.id, job: 'janitor'
    )
    @request.host = "#{@institution.identification}.lvh.me"
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test 'should change password via token url' do
    @user.send(:generate_reset_password_token!)

    get :edit, reset_password_token: @user.reset_password_token

    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'devise/passwords/edit'
  end

  test 'should validate expired token' do
    @user.send(:generate_reset_password_token!)
    @user.update_column(:reset_password_sent_at,
      Time.zone.now - Devise.reset_password_within)

    get :edit, reset_password_token: @user.reset_password_token

    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'devise/passwords/expired_token'
  end

  test 'should validate blank token url' do

    get :edit, reset_password_token: ''

    assert_response :success
    assert_not_nil assigns(:user)
    assert_select '#unexpected_error', false
    assert_template 'devise/passwords/confirmation_token'
  end

  test 'should send welcome instructions' do

    assert_difference 'ActionMailer::Base.deliveries.size' do
      post :create, user: { email: @user.email, welcome: 'true' }
    end

    mail = ActionMailer::Base.deliveries.last

    assert_equal I18n.t('devise.mailer.welcome_instructions.subject'), mail.subject
  end

  test 'should send forgot password instructions' do

    assert_difference 'ActionMailer::Base.deliveries.size' do
      post :create, user: { email: @user.email }
    end

    mail = ActionMailer::Base.deliveries.last

    assert_equal I18n.t('devise.mailer.reset_password_instructions.subject'), mail.subject
  end
end
