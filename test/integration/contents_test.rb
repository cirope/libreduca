# encoding: utf-8

require 'test_helper'

class ContentsTest < ActionDispatch::IntegrationTest
  test 'should create a new content' do
    login
    
    teach = Fabricate(:teach)
    content = Fabricate.build(:content, teach_id: teach.id)
    
    visit new_teach_content_path(teach)
    
    fill_in Content.human_attribute_name('title'), with: content.title
    fill_in Content.human_attribute_name('content'), with: content.content

    document = Fabricate.build(:document, owner_id: nil)

    assert page.has_no_css?('.document')
    
    click_link I18n.t('view.contents.new_document')
      
    within '.document' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end

    assert page.has_no_css?('.document:nth-child(2)')
    
    click_link I18n.t('view.contents.new_document')
    
    assert page.has_css?('.document:nth-child(2)')
    
    document = Fabricate.build(:document, owner_id: nil)
      
    within '.document:nth-child(2)' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end
    
    assert_difference 'Content.count' do
      assert_difference 'Document.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should delete all document inputs' do
    login
    
    teach = Fabricate(:teach)
    
    visit new_teach_content_path(teach)
    
    assert page.has_no_css?('.document')

    click_link I18n.t('view.contents.new_document')

    assert page.has_css?('.document')
    
    within '.document' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('.document')
  end
  
  test 'should hide and mark for destruction an document' do
    login
    
    content = Fabricate(:content)
    document = Fabricate(
      :document, owner_id: content.id, owner_type: 'Content'
    )
    
    visit edit_teach_content_path(content.teach, content)
    
    assert page.has_css?('.document')
    
    within '.document' do
      click_link '✘' # Destroy link
    end
    
    assert_no_difference 'Content.count' do
      assert_difference 'Document.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end
end
