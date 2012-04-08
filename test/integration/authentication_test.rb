require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @school = Fabricate(:school)
  end
  
  test 'should be able to login and logout as admin' do
    login
    
    click_link 'logout'
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert')
    
    within 'footer.alert' do
      assert page.has_content?(I18n.t('devise.sessions.signed_out'))
    end
  end
  
  test 'should be able to login as related to school' do
    Capybara.app_host = "http://#{@school.identification}.lvh.me:54163"
    
    user = Fabricate(:user, password: '123456', roles: [:normal])
    job = Fabricate(:job, user_id: user.id, school_id: @school.id)
    expected_path = url_for(
      controller: 'dashboard', action: job.job, only_path: true
    )
    
    login user: user, clean_password: '123456', expected_path: expected_path
  end
  
  test 'should not be able to login as no related to school' do
    Capybara.app_host = "http://#{@school.identification}.lvh.me:54163"
    
    user = Fabricate(:user, password: '123456', roles: [:normal])
    
    invalid_login user: user, clean_password: '123456'
  end
  
  test 'should not be able to login as normal user in admin page' do
    user = Fabricate(:user, password: '123456', roles: [:normal])
    
    Fabricate(:job, user_id: user.id, school_id: @school.id)
    
    invalid_login user: user, clean_password: '123456'
  end
  
  private
  
  def invalid_login(options = {})
    clean_password = options[:clean_password] || '123456'
    user = options[:user] || Fabricate(:user, password: clean_password)
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: clean_password
    
    find('.btn.btn-primary').click
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert')
    
    within 'footer.alert' do
      assert page.has_content?(I18n.t('devise.failure.invalid'))
    end
  end
end
