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

    click_link Survey.model_name.human(count: 0)

    assert page.has_no_css?('#surveys_content fieldset')

    click_link I18n.t('view.contents.surveys.new')

    within '#surveys_content fieldset' do
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

    click_link Document.model_name.human(count: 0)

    assert page.has_no_css?('#documents_content fieldset')
    
    click_link I18n.t('view.contents.new_document')

    within '#documents_content fieldset' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end

    assert page.has_no_css?('#documents_content fieldset:nth-child(2)')
    
    click_link I18n.t('view.contents.new_document')
    
    assert page.has_css?('#documents_content fieldset:nth-child(2)')
    
    document = Fabricate.build(:document, owner_id: nil)
      
    within '#documents_content fieldset:nth-child(2)' do
      fill_in find('input[name$="[name]"]')[:id], with: document.name
      attach_file find('input[name$="[file]"]')[:id], document.file.path
    end

    homework = Fabricate.build(:homework, content_id: nil)

    click_link Homework.model_name.human(count: 0)

    assert page.has_no_css?('#homeworks_content fieldset')
    
    click_link I18n.t('view.contents.homeworks.new')

    within '#homeworks_content fieldset' do
      fill_in find('input[name$="[name]"]')[:id], with: homework.name

      fill_in find('textarea[name$="[description]"]')[:id],
        with: homework.description

      find('input[name$="[closing_at]"]').click
    end
  
    within '.ui-datepicker-calendar' do
      find('a.ui-state-default.ui-state-highlight').click
     end

    counts = [
      'Content.count', 'Survey.count', 'Question.count', 'Answer.count',
      'Homework.count'
    ]
    
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
    
    assert page.has_no_css?('#documents_content fieldset')

    click_link I18n.t('view.contents.new_document')

    assert page.has_css?('#documents_content fieldset')
    
    within '#documents_content fieldset' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('#documents_content fieldset')
  end
  
  test 'should hide and mark for destruction a document' do
    login
    
    content = Fabricate(:content)
    document = Fabricate(
      :document, owner_id: content.id, owner_type: 'Content'
    )
    
    visit edit_teach_content_path(content.teach, content)
    
    assert page.has_css?('#documents_content fieldset')
    
    within '#documents_content fieldset' do
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

    click_link Survey.model_name.human(count: 0)
    
    assert page.has_css?('#surveys_content fieldset')
    
    within '#surveys_content fieldset:first-child' do
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
    content = Fabricate(:content)
    survey = Fabricate(:survey, content_id: content.id)
  
    2.times do
      question = Fabricate(:question, survey_id: survey.id)

      3.times { Fabricate(:answer, question_id: question.id) }
    end

    login_into_institution institution: content.institution, as: 'student'

    Fabricate(
      :enrollment,
      user_id: @test_user.id,
      teach_id: content.teach_id, job: 'student'
    )
    
    visit teach_content_path(content.teach, content)
    
    assert page.has_css?('form.new_reply input')

    assert_difference 'Reply.count', 2 do
      all('form.new_reply').each do |form|
        form.first(:css, 'input[type="radio"]').click
      end

      assert page.has_no_css?('form.new_reply')
    end
  end

  test 'should upload a presentation' do
    login_into_institution as: 'student'
    
    homework = Fabricate(:homework)
    content = homework.content
    presentation = Fabricate.build(:presentation, homework_id: homework.id, user_id: nil)
    Fabricate(:enrollment, user_id: @test_user.id, teach_id: content.teach_id)
  
    visit teach_content_path(content.teach, content)
    
    assert page.has_css?("#presentation_file_#{homework.to_param}")
    assert page.has_no_css?('.upload')

    assert_difference 'Presentation.count' do
      attach_file "presentation_file_#{homework.to_param}", presentation.file.path

      assert page.has_css?('.upload')
      assert page.has_no_css?('.upload') # Wait until the file is uploaded
    end
  end
end
