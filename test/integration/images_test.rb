# encoding: utf-8

require 'test_helper'

class ImagesTest < ActionDispatch::IntegrationTest
  test 'should create image' do
    login_into_institution as: 'teacher'
    
    visit new_image_path

    assert page.has_no_css?('.upload')

    image_attributes = Fabricate.attributes_for(:image, raw_file_path: true)
    
    assert_difference 'Image.count' do
      fill_in 'image_name', with: image_attributes['name']
      attach_file 'image_file', image_attributes['file']
      
      assert page.has_css?('.upload')
      assert page.has_css?('.readonly-data')
      assert_page_has_no_errors!
    end
  end
end
