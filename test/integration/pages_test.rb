# encoding: utf-8

require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  test 'should create a block in pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate.build(:block, blockable_id: page_block.id, blockable_type: 'Page')

    login_into_institution institution: institution,
      user: user, as: 'janitor'

    visit page_path(institution)

    assert_difference('page_block.blocks.count') do
      find('#create-block').click

      assert page.has_css?('#block_content')

      fill_in 'block_content', with: block.content
      find('.new_block .btn').click

      assert page.has_no_css?('#block_content')
    end
  end

  test 'should edit a block in pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate(:block, blockable_id: page_block.id, blockable_type: 'Page')

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    visit page_path(institution)

    assert_no_difference('page_block.blocks.count') do
      find('.edit-action').click

      assert page.has_css?('#block_content')

      fill_in 'block_content', with: 'Upd'
      find('.edit_block .btn').click

      assert page.has_no_css?('#block_content')
    end

    assert_equal 'Upd', block.reload.content
  end

  test 'should delete a block from pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    page_block = Fabricate(:page, institution_id: institution.id)
    block = Fabricate.build(:block, blockable_id: page_block.id, blockable_type: 'Page')
    block.save!

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    visit page_path(institution)

    assert_difference('page_block.blocks.count', -1) do
      find('.content a[data-method="delete"]').click

      page.driver.browser.switch_to.alert.accept

      assert page.has_no_css?('.block')
    end
  end

  test 'should sort blocks from pages' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', role: :normal)
    page_block = Fabricate(:page, institution_id: institution.id)
    2.times { |c| Fabricate(:block, content: c, blockable_id: page_block.id, blockable_type: 'Page') }

    login_into_institution institution: institution, expected_path: page_path(institution.id),
      user: user, as: 'janitor'

    source = find("#block-1").find('.handle')
    target = find("#block-2").find('.handle')
    safe_drag_and_drop(source, target)

    visit page_path(institution)

    assert_equal first('.block'), find("#block-2")
    assert Block.where(content: '0').first.position > Block.where(content: '1').first.position
  end
end
