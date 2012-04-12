# encoding: utf-8

require 'test_helper'

class PublicUserInteractionsTest < ActionDispatch::IntegrationTest
  test 'should ask for login' do
    visit root_path
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert')
    
    within 'footer.alert' do
      assert page.has_content?(I18n.t('devise.failure.unauthenticated'))
    end
  end
  
  test 'should send reset password instructions' do
    user = Fabricate(:user)
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    find("a[href='#{new_user_password_path}']").click
    
    assert_equal new_user_password_path, current_path
    assert_page_has_no_errors!
    
    fill_in 'user_email', with: user.email
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      find('.btn.btn-primary').click
    end
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert')
    
    within 'footer.alert' do
      assert page.has_content?(I18n.t('devise.passwords.send_instructions'))
    end
  end
end
