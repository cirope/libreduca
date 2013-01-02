# encoding: utf-8

require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  test 'should create a block in pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', roles: [:janitor])
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate.build(:block, blockable_id: page_block.id, blockable_type: 'Page')

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    assert_difference('page_block.blocks(:reload).count') do
      find('.new-action').click

      find('#block_content').set block.content
      find('.create-action').click
      sleep 1
    end
  end

  test 'should edit a block in pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', roles: [:janitor])
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate(:block, blockable_id: page_block.id, blockable_type: 'Page')

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    assert_no_difference('page_block.blocks(:reload).count') do
      find('.edit-action').click

      find('#block_content').set "Upd"
      find('.save-action').click
      sleep 1
    end

    assert_equal "Upd", block.reload.content
  end

  test 'should delete a block from pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', roles: [:janitor])
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate.build(:block, blockable_id: page_block.id, blockable_type: 'Page')
    block.save!

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    assert_difference('page_block.blocks(:reload).count', -1) do
      find('.delete-action').click
      page.driver.browser.switch_to.alert.accept
      sleep 1
    end
  end
end
