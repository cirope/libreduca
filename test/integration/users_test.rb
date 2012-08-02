# encoding: utf-8

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'should create a new user with jobs' do
    login
    
    visit new_user_path
    
    user_attributes = Fabricate.attributes_for(:user)
    
    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    
    find('#user_role_admin').click
    
    school = Fabricate(:school)
    
    within '.job' do
      fill_in find('input[name$="[auto_school_name]"]')[:id], with: school.name
    end
      
    find('.ui-autocomplete li.ui-menu-item a').click
      
    within '.job' do
      select I18n.t("view.jobs.types.#{Job::TYPES.first}"),
        from: find('select[name$="[job]"]')[:id]
    end
    
    assert page.has_no_css?('.job:nth-child(2)')
    
    click_link I18n.t('view.users.new_job')
    
    assert page.has_css?('.job:nth-child(2)')
    
    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').remove()")
    
    school = Fabricate(:school)
    
    within '.job:nth-child(2)' do
      fill_in find('input[name$="[auto_school_name]"]')[:id], with: school.name
    end
    
    find('.ui-autocomplete li.ui-menu-item a').click
    
    within '.job:nth-child(2)' do
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
    
    user_attributes = Fabricate.attributes_for(:user)
    
    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']
    
    find('#user_role_admin').click
    
    relative = Fabricate(:user)
    
    within '.kinship' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end
      
    find('.ui-autocomplete li.ui-menu-item a').click
      
    within '.kinship' do
      select I18n.t("view.kinships.types.#{Kinship::TYPES.first}"),
        from: find('select[name$="[kin]"]')[:id]
    end
    
    assert page.has_no_css?('.kinship:nth-child(2)')
    
    click_link I18n.t('view.users.new_kinship')
    
    assert page.has_css?('.kinship:nth-child(2)')
    
    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').remove()")
    
    relative = Fabricate(:user)
    
    within '.kinship:nth-child(2)' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end
    
    find('.ui-autocomplete li.ui-menu-item a').click
    
    within '.kinship:nth-child(2)' do
      select I18n.t("view.kinships.types.#{Kinship::TYPES.first}"),
        from: find('select[name$="[kin]"]')[:id]
    end
    
    assert_difference 'User.count' do
      assert_difference 'Kinship.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should delete all job inputs' do
    login
    
    visit new_user_path
    
    assert page.has_css?('.job')
    
    within '.job' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('.job')
  end
  
  test 'should delete all kinship inputs' do
    login
    
    visit new_user_path
    
    assert page.has_css?('.kinship')
    
    within '.kinship' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('.kinship')
  end
  
  test 'should hide and mark for destruction a job' do
    login
    
    user = Fabricate(:user) { jobs { [Fabricate(:job)] } }
    
    visit edit_user_path(user)
    
    assert page.has_css?('.job')
    
    within '.job' do
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
    
    assert page.has_css?('.kinship')
    
    within '.kinship' do
      click_link '✘' # Destroy link
    end
    
    assert_no_difference 'User.count' do
      assert_difference 'Kinship.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end
end
