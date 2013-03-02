# encoding: utf-8

require 'test_helper'

class PublicUserInteractionsTest < ActionDispatch::IntegrationTest

  test 'should ask for login' do
    visit new_user_session_path

    assert_equal new_user_session_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')
  end

  test 'should send reset password instructions' do
    user = Fabricate(:user)

    visit new_user_session_path

    assert_page_has_no_errors!

    find('#reset-password').click

    assert_equal new_user_password_path, current_path
    assert_page_has_no_errors!

    fill_in 'user_email', with: user.email

    assert_difference 'ActionMailer::Base.deliveries.size' do
      find('.btn-primary.submit').click
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

    click_link 'logout'

    assert_equal new_user_session_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert.alert-info')

    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.sessions.signed_out'))
    end
  end

  test 'should be redirected to subdomain' do
    login_into_institution

    click_link 'logout'

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

    within '.login' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'

      find('.btn.btn-primary').click
    end

    assert_equal student_dashboard_path, current_path
  end

  test 'should login via _menu dropdown_' do

    institution = Fabricate(:institution)
    Fabricate(:news, institution_id: institution.id)
    user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(
      :job, user_id: user.id, institution_id: institution.id, job: 'student'
    )

    Capybara.app_host = "http://#{institution.identification}.lvh.me:54163"

    visit news_index_path

    assert_page_has_no_errors!

    within '.content .navbar' do
      click_link 'Ingresar'

      within '#login' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: '123456'

        find('.btn.btn-primary').click
      end
    end

    assert page.has_css?('.alert.alert-info')

    within '.alert.alert-info' do
      assert page.has_content?(I18n.t('devise.sessions.signed_in'))
    end
  end

  test 'should login with two jobs' do
    @test_institution_one = Fabricate(:institution)
    @test_institution_two = Fabricate(:institution)
    Capybara.app_host = "http://www.lvh.me:54163"

    user = Fabricate(:user, password: '123456', roles: [:normal])
    job_one = Fabricate(
      :job, user_id: user.id, institution_id: @test_institution_one.id, job: 'student'
    )
    job_two = Fabricate(
      :job, user_id: user.id, institution_id: @test_institution_two.id, job: 'student'
    )

    page_block = Fabricate(:page, institution_id: @test_institution_one.id)
    block = Fabricate(:block, blockable_id: page_block.id, blockable_type: 'Page')

    visit root_path

    assert_page_has_no_errors!

    within '.login' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'

      find('.btn.btn-primary').click
    end

    assert_equal launchpad_path, current_path

    assert has_link? @test_institution_one, page_path(page_block)
    assert has_link? @test_institution_two, student_dashboard_path
  end
end
