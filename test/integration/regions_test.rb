require 'test_helper'

class RegionsTest < ActionDispatch::IntegrationTest
  include Integration::Login

  test 'should add districts to region' do
    login

    visit new_region_path

    fill_in 'region_name', with: Fabricate.attributes_for(:region)['name']
    fill_in 'region_districts_attributes_0_name',
      with: Fabricate.attributes_for(:district)['name']

    assert page.has_no_css?('.district:nth-child(2)')

    click_link I18n.t('view.regions.new_district')

    assert page.has_css?('#districts fieldset:nth-child(2)')

    within '#districts fieldset:nth-child(2)' do
      fill_in find('input[name$="[name]"]')[:id],
        with: Fabricate.attributes_for(:district)['name']
    end

    assert_difference 'Region.count' do
      assert_difference 'District.count', 2 do
        find('.btn.btn-primary').click
      end
    end

    assert_page_has_no_errors!
    assert page.has_css?('.alert-info')

    within '.alert-info' do
      assert page.has_content?(I18n.t('view.regions.correctly_created'))
    end
  end

  test 'should delete all districts inputs' do
    login

    visit new_region_path

    assert page.has_css?('#districts fieldset')

    within '#districts fieldset' do
      find('.glyphicon-remove-circle').click
    end

    assert page.has_no_css?('#districts fieldset')
  end
end
