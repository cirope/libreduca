require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @institution = Fabricate(:institution)
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
  
  test 'should be able to login as related to institution' do
    assert_difference 'Login.count' do
      login_into_institution institution: @institution
    end
  end
  
  test 'should not be able to login as no related to institution' do
    Capybara.app_host = "http://#{@institution.identification}.lvh.me:54163"
    
    user = Fabricate(:user, password: '123456', roles: [:normal])
    
    assert_no_difference 'Login.count' do
      invalid_login user: user, clean_password: '123456'
    end
  end
  
  test 'should normal user be redirected to his own subdomain in admin page' do
    user = Fabricate(:user, password: '123456', roles: [:normal])
    
    job = Fabricate(:job, user_id: user.id, institution_id: @institution.id)

    expected_path = url_for(
      controller: 'dashboard', action: job.job, only_path: true
    )
    
    login user: user, clean_password: '123456', expected_path: expected_path

    assert_match /\Ahttp:\/\/#{@institution.identification}\./, current_url
  end

  test 'should normal user be redirected to launchpad in admin page' do
    user = Fabricate(:user, password: '123456', roles: [:normal])
    
    Fabricate(:job, user_id: user.id, institution_id: @institution.id)
    Fabricate(:job, user_id: user.id)

    login user: user, clean_password: '123456', expected_path: launchpad_path

    assert_match launchpad_path, current_path
  end

  
  private
  
  def invalid_login(options = {})
    clean_password = options[:clean_password] || '123456'
    user = options[:user] || Fabricate(:user, password: clean_password)
    
    visit new_user_session_path
    
    assert_page_has_no_errors!
    
    within '.login' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: clean_password
      
      find('.btn.btn-primary').click
    end
    
    assert_equal new_user_session_path, current_path
    
    assert_page_has_no_errors!
    assert page.has_css?('.alert')
    
    within 'footer.alert' do
      assert page.has_content?(I18n.t('devise.failure.invalid'))
    end
  end
end
