# encoding: utf-8

require 'test_helper'

class GroupsTest < ActionDispatch::IntegrationTest
  test 'should create new group' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    group = Fabricate.attributes_for(:group)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit groups_path

    find('a.btn.btn-primary').click

    fill_in 'Nombre', with: group['name']

    assert_difference('Group.count') do
      assert page.has_css?('#new_group')

      find('input.btn.btn-primary').click

      assert page.has_no_css?('#new_group')
      assert page.has_css?('.alert-info')
    end
  end

  test 'should update a group' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    group = Fabricate(:group, institution_id: institution.id)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit edit_group_path(group)

    fill_in 'Nombre', with: "Upd"

    assert_no_difference('Group.count') do
      assert page.has_css?("#edit_group_#{group.id}")

      find('input.btn.btn-primary').click

      assert page.has_no_css?("#edit_group_#{group.id}")
      assert page.has_css?('.alert-info')

      assert_equal group.reload.name, "Upd"
    end
  end

  test 'should add a user within a group' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    group = Fabricate(:group, institution_id: institution.id)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit edit_group_path(group)

    find('a.btn.btn-small').click

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    within "#edit_group_#{group.id} fieldset" do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: "#{user.name} #{user.lastname}"
    end

    assert page.has_css?('.ui-autocomplete li.ui-menu-item a')

    find('.ui-autocomplete li.ui-menu-item a').click

    assert_difference('Membership.count') do
      assert page.has_css?("#edit_group_#{group.id}")

      find('input.btn.btn-primary').click

      assert page.has_no_css?("#edit_group_#{group.id}")
      assert page.has_css?('.alert-info')
    end
  end

  test 'should remove a user from a group' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    another_user = Fabricate(:user)
    job = Fabricate(:job, user_id: another_user.id, institution_id: institution.id)
    group = Fabricate(:group, institution_id: institution.id)
    membership = Fabricate(:membership, user_id: user.id, group_id: group.id)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit edit_group_path(group)

    assert_difference('Membership.count', -1) do
      assert page.has_css?("#edit_group_#{group.id}")

      within "#edit_group_#{group.id} fieldset" do
        find('div a[data-dynamic-form-event="hideItem"]').click
      end

      find('input.btn.btn-primary').click

      assert page.has_no_css?("#edit_group_#{group.id}")
      assert page.has_css?('.alert-info')
    end
  end

  test 'should destroy a group' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    group = Fabricate(:group, institution_id: institution.id)

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit groups_path

    assert_difference('Group.count', -1) do
      assert page.has_no_css?('.alert-info')

      find('div a[data-original-title="Eliminar"]').click

      page.driver.browser.switch_to.alert.accept

      assert page.has_css?('.alert')
    end
  end
end
