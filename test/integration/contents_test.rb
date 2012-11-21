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

    survey = Fabricate.build(:survey, content_id: nil)

    assert page.has_no_css?('#surveys fieldset')

    click_link I18n.t('view.contents.surveys.new')

    within '#surveys fieldset' do
      fill_in find('input[name$="[name]"]')[:id], with: survey.name

      question = Fabricate.build(:question, survey_id: nil)

      assert page.has_no_css?('fieldset')
      
      click_link I18n.t('view.contents.surveys.new_question')

      within 'fieldset' do
        fill_in find('input[name$="[content]"]')[:id], with: question.content

        answer = Fabricate.build(:answer, question_id: nil)

        assert page.has_no_css?('fieldset')
                    
        click_link I18n.t('view.contents.surveys.new_answer')

        within 'fieldset' do
          fill_in find('input[name$="[content]"]')[:id], with: answer.content
        end
      end
    end

    document = Fabricate.build(:document, owner_id: nil)

    assert page.has_no_css?('#documents fieldset')
    
    click_link I18n.t('view.contents.new_document')

    within '#documents fieldset' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end

    assert page.has_no_css?('#documents fieldset:nth-child(2)')
    
    click_link I18n.t('view.contents.new_document')
    
    assert page.has_css?('#documents fieldset:nth-child(2)')
    
    document = Fabricate.build(:document, owner_id: nil)
      
    within '#documents fieldset:nth-child(2)' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end

    counts = ['Content.count', 'Survey.count', 'Question.count', 'Answer.count']
    
    assert_difference counts do
      assert_difference 'Document.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should delete all document inputs' do
    login
    
    teach = Fabricate(:teach)
    
    visit new_teach_content_path(teach)
    
    assert page.has_no_css?('#documents fieldset')

    click_link I18n.t('view.contents.new_document')

    assert page.has_css?('#documents fieldset')
    
    within '#documents fieldset' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('#documents fieldset')
  end
  
  test 'should hide and mark for destruction a document' do
    login
    
    content = Fabricate(:content)
    document = Fabricate(
      :document, owner_id: content.id, owner_type: 'Content'
    )
    
    visit edit_teach_content_path(content.teach, content)
    
    assert page.has_css?('#documents fieldset')
    
    within '#documents fieldset' do
      click_link '✘' # Destroy link
    end
    
    assert_no_difference 'Content.count' do
      assert_difference 'Document.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should hide and mark for destruction a survey' do
    login
    
    content = Fabricate(:content)
    survey = Fabricate(:survey, content_id: content.id)
  
    2.times do
      question = Fabricate(:question, survey_id: survey.id)

      3.times { Fabricate(:answer, question_id: question.id) }
    end
    
    visit edit_teach_content_path(content.teach, content)
    
    assert page.has_css?('#surveys fieldset')
    
    within '#surveys fieldset:first-child' do
      first('a[data-dynamic-target=".survey"]').click # Destroy link
    end
    
    assert_no_difference 'Content.count' do
      assert_difference 'content.surveys.count', -1 do
        assert_difference 'Question.count', -2 do
          assert_difference 'Answer.count', -6 do
            find('.btn.btn-primary').click
          end
        end
      end
    end
  end

  test 'should answer a survey' do
    login
    
    content = Fabricate(:content)
    survey = Fabricate(:survey, content_id: content.id)
  
    2.times do
      question = Fabricate(:question, survey_id: survey.id)

      3.times { Fabricate(:answer, question_id: question.id) }
    end
    
    visit teach_content_path(content.teach, content)
    
    assert page.has_css?('form.new_reply input')

    assert_difference 'Reply.count', 2 do
      all('form.new_reply').each do |form|
        form.first(:css, 'input[type="radio"]').click
      end

      assert page.has_no_css?('form.new_reply')
    end
  end
end
