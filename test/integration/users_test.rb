# encoding: utf-8

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'should create a new user with jobs' do
    login

    visit new_user_path

    user_attributes = Fabricate.attributes_for(:user, raw_avatar_path: true)

    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    attach_file 'user_avatar', user_attributes['avatar']

    find('#user_role_admin').click

    institution = Fabricate(:institution)

    within '#jobs fieldset' do
      fill_in find('input[name$="[auto_institution_name]"]')[:id], with: institution.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#jobs fieldset' do
      select I18n.t("view.jobs.types.#{Job::TYPES.first}"),
        from: find('select[name$="[job]"]')[:id]
    end

    assert page.has_no_css?('#jobs fieldset:nth-child(2)')

    click_link I18n.t('view.users.new_job')

    assert page.has_css?('#jobs fieldset:nth-child(2)')

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    institution = Fabricate(:institution)

    within '#jobs fieldset:nth-child(2)' do
      fill_in find('input[name$="[auto_institution_name]"]')[:id], with: institution.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#jobs fieldset:nth-child(2)' do
      select I18n.t("view.jobs.types.#{Job::TYPES.first}"),
        from: find('select[name$="[job]"]')[:id]
    end

    assert_difference 'User.count' do
      assert_difference 'Job.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should create a new user with kinships' do
    login

    visit new_user_path

    user_attributes = Fabricate.attributes_for(:user, raw_avatar_path: true)

    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    attach_file 'user_avatar', user_attributes['avatar']

    find('#user_role_admin').click

    relative = Fabricate(:user)

    within '#kinships fieldset' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#kinships fieldset' do
      select I18n.t("view.kinships.types.#{Kinship::TYPES.first}"),
        from: find('select[name$="[kin]"]')[:id]
    end

    assert page.has_no_css?('#kinships fieldset:nth-child(2)')

    click_link I18n.t('view.users.new_kinship')

    assert page.has_css?('#kinships fieldset:nth-child(2)')

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    relative = Fabricate(:user)

    within '#kinships fieldset:nth-child(2)' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#kinships fieldset:nth-child(2)' do
      select I18n.t("view.kinships.types.#{Kinship::TYPES.first}"),
        from: find('select[name$="[kin]"]')[:id]
    end

    assert_difference 'User.count' do
      assert_difference 'Kinship.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should create a new user as janitor' do
    institution = Fabricate(:institution)

    login_into_institution institution: institution, as: 'janitor'

    visit new_user_path

    user_attributes = Fabricate.attributes_for(:user, raw_avatar_path: true)

    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    attach_file 'user_avatar', user_attributes['avatar']

    assert page.has_no_css?('#user_role_admin')
    assert page.has_no_css?('#jobs fieldset input[name$="[auto_institution_name]"]')

    within '#jobs fieldset' do
      select I18n.t("view.jobs.types.#{Job::TYPES.first}"),
        from: find('select[name$="[job]"]')[:id]
    end

    assert_difference ['User.count', 'Job.count'] do
      find('.btn.btn-primary').click
    end
  end

  test 'should create a new user as janitor and add it to a group' do
    institution = Fabricate(:institution)
    group = Fabricate(:group, institution_id: institution.id)

    login_into_institution institution: institution, as: 'janitor'

    visit new_user_path

    user_attributes = Fabricate.attributes_for(:user, raw_avatar_path: true)

    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    attach_file 'user_avatar', user_attributes['avatar']

    assert page.has_no_css?('#user_role_admin')

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    within '#jobs fieldset' do
      select I18n.t("view.jobs.types.#{Job::TYPES.first}"),
        from: find('select[name$="[job]"]')[:id]
    end

    within '#groups fieldset' do
      fill_in find('input[name$="[auto_group_name]"]')[:id], with: group.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    assert_difference ['User.count', 'Membership.count'] do
      find('.btn.btn-primary').click
    end
  end


  test 'should delete all job inputs' do
    login

    visit new_user_path

    assert page.has_css?('#jobs fieldset')

    within '#jobs fieldset' do
      click_link '✘' # Destroy link
    end

    assert page.has_no_css?('#jobs fieldset')
  end

  test 'should delete all kinship inputs' do
    login

    visit new_user_path

    assert page.has_css?('#kinships fieldset')

    within '#kinships fieldset' do
      click_link '✘' # Destroy link
    end

    assert page.has_no_css?('#kinships fieldset')
  end

  test 'should hide and mark for destruction a job' do
    login

    user = Fabricate(:user) { jobs { [Fabricate(:job)] } }

    visit edit_user_path(user)

    assert page.has_css?('#jobs fieldset')

    within '#jobs fieldset' do
      click_link '✘' # Destroy link
    end

    assert_no_difference 'User.count' do
      assert_difference 'Job.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should hide and mark for destruction a kinship' do
    login

    user = Fabricate(:user) { kinships { [Fabricate(:kinship)] } }

    visit edit_user_path(user)

    assert page.has_css?('#kinships fieldset')

    within '#kinships fieldset:nth-child(1)' do
      click_link '✘' # Destroy link
    end

    assert_no_difference 'User.count' do
      assert_difference 'Kinship.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end
end
