require 'test_helper'

class PublicUserInteractionsTest < ActionDispatch::IntegrationTest
  include Integration::Login

  test 'should ask for login' do
    visit new_user_session_path

    assert_equal new_user_session_path, current_path

    assert_page_has_no_errors!
  end

  test 'should send reset password instructions' do
    user = Fabricate(:user)

    visit new_user_session_path

    assert_page_has_no_errors!

    click_link I18n.t('sessions.new.forgot_password')

    assert page.has_css?('.email')
    assert_equal new_user_password_path, current_path
    assert_page_has_no_errors!

    fill_in 'user_email', with: user.email

    assert_difference 'ActionMailer::Base.deliveries.size' do
      find('.btn-primary').click
    end

    assert_equal new_user_session_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert.alert-info')

    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.passwords.send_instructions'))
    end
  end

  test 'should be able to login and logout' do
    login

    within '.navbar-collapse .navbar-right' do
      find('a.dropdown-toggle').click
      click_link I18n.t('navigation.logout')
    end

    assert_equal new_user_session_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert.alert-info')

    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.sessions.signed_out'))
    end
  end

  test 'should be redirected to subdomain' do
    login_into_institution

    within '.navbar-collapse .navbar-right' do
      find('a.dropdown-toggle').click
      click_link I18n.t('navigation.logout')
    end

    visit student_dashboard_path

    Capybara.app_host = "http://#{RESERVED_SUBDOMAINS.first}.lvh.me:54163"

    visit new_user_session_path

    login user: @test_user, expected_path: student_dashboard_path

    assert_equal(
      "http://#{@test_institution.identification}.lvh.me:54163#{student_dashboard_path}",
      current_url
    )
  end

  test 'should login via _welcome page_' do
    @test_institution = Fabricate(:institution)
    Capybara.app_host = "http://#{@test_institution.identification}.lvh.me:54163"

    user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(
      :job, user_id: user.id, institution_id: @test_institution.id, job: 'student'
    )

    visit root_path

    assert_page_has_no_errors!

    within '#new_user' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'

      find('.btn.btn-primary').click
    end

    assert_equal student_dashboard_path, current_path
  end

  test 'should login via news' do

    institution = Fabricate(:institution)
    Fabricate(:news, institution_id: institution.id)
    user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(
      :job, user_id: user.id, institution_id: institution.id, job: 'student'
    )

    Capybara.app_host = "http://#{institution.identification}.lvh.me:54163"

    visit news_index_path

    assert_page_has_no_errors!

    click_link 'Ingresar'

    assert page.has_css?('#user_email')

    within '#new_user' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'

      find('.btn.btn-primary').click
    end

    assert page.has_css?('.alert.alert-info')

    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.sessions.signed_in'))
    end
  end
end
