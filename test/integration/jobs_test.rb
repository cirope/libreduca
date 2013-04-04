# encoding: utf-8

require 'test_helper'

class JobsTest < ActionDispatch::IntegrationTest
  include Integration::Login

  test 'should create existing user in a new institution that does belongs' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    another_user = Fabricate(:user)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit new_user_path

    fill_in 'user_email', with: another_user.email
    find('#user_name').click

    select(I18n.t('view.jobs.types.student'), from: 'job_job')

    assert_difference('Job.count') do
      assert page.has_css?('#new_job')

      find('.btn-primary').click

      assert page.has_no_css?('#new_job')
      assert page.has_css?('.alert-info')
    end
  end

  test 'should not create existing user in a new institution that does not belongs' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    another_institution = Fabricate(:institution)
    another_user = Fabricate(:user)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit new_user_path

    fill_in 'user_email', with: another_user.email
    find('#user_name').click

    select(I18n.t('view.jobs.types.student'), from: 'job_job')

    assert_no_difference('Job.count') do

      page.execute_script("$('#job_institution_id').val(#{another_institution.id})")
      assert page.has_css?('#new_job')

      find('.btn-primary').click

      assert page.has_no_css?('#new_job')
      assert page.has_css?('.alert-error')
    end
  end
end
