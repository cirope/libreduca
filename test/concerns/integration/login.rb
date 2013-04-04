module Integration
  module Login
    extend ActiveSupport::Concern

    def login(options = {})
      clean_password = options[:clean_password] || '123456'
      user = options[:user] || Fabricate(:user, password: clean_password)
      expected_path = options[:expected_path]
      expected_path ||= user.is?(:admin) ? institutions_path : dashboard_path

      visit new_user_session_path

      assert_page_has_no_errors!

      within '.login' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: clean_password

        find('.btn.btn-primary').click
      end

      assert_equal expected_path, current_path

      assert_page_has_no_errors!
      assert page.has_css?('.alert.alert-info')

      within '.alert.alert-info' do
        assert page.has_content?(I18n.t('devise.sessions.signed_in'))
      end
    end

    def login_into_institution(options = {})
      @test_institution = options[:institution] || Fabricate(:institution)
      Capybara.app_host = "http://#{@test_institution.identification}.lvh.me:54163"

      @test_user = options[:user] || Fabricate(:user, password: '123456', roles: [:normal])
      job = Fabricate(
        :job, user_id: @test_user.id, institution_id: @test_institution.id, job: options[:as] || 'student'
      )
      expected_path = options[:expected_path]
      expected_path ||= url_for(
        controller: 'dashboard', action: job.job, only_path: true
      )

      login user: @test_user, clean_password: '123456', expected_path: expected_path
    end
  end
end
