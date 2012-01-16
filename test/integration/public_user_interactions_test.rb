# encoding: utf-8

require 'test_helper'

class PublicUserInteractionsTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end
  
  test 'should ask for login' do
    visit root_path
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert-message')
    
    within '.alert-message' do
      assert page.has_content?(I18n.t('devise.failure.unauthenticated'))
    end
  end
  
  test 'should send reset password instructions' do
    user = Fabricate(:user)
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    click_link '¿Olvidaste tu contraseña?'
    
    assert_equal new_user_password_path, current_path
    assert_page_has_no_errors!
    
    fill_in 'user_email', with: user.email
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      find('input.btn.primary').click
    end
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert-message')
    
    within '.alert-message' do
      assert page.has_content?(I18n.t('devise.passwords.send_instructions'))
    end
  end
  
  test 'should be able to login and logout' do
    user = Fabricate(:user, password: '123456')
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: '123456'
    
    find('input.btn.primary').click
    
    assert_equal root_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert-message')
    
    within '.alert-message' do
      assert page.has_content?(I18n.t('devise.sessions.signed_in'))
    end
    
    click_link I18n.t('menu.actions.logout.link')
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert-message')
    
    within '.alert-message' do
      assert page.has_content?(I18n.t('devise.sessions.signed_out'))
    end
  end
end
