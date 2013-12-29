require 'test_helper'

class ContentsTest < ActionDispatch::IntegrationTest
  include Integration::Login

  test 'should create a new content' do
    login

    teach = Fabricate(:teach)
    content = Fabricate.build(:content, teach_id: teach.id)

    visit new_teach_content_path(teach)

    fill_in Content.human_attribute_name('title'), with: content.title
    fill_in Content.human_attribute_name('content'), with: content.content

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

    assert_difference ['Content.count', 'Homework.count'] do
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
      find("[data-dynamic-target=\".document\"]").click
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
      find("[data-dynamic-target=\".document\"]").click
    end

    assert_no_difference 'Content.count' do
      assert_difference 'Document.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should answer a survey' do
    content = Fabricate(:content)
    survey = Fabricate(:survey, content_id: content.id)

    Question::TYPES.each do |qt|
      question = Fabricate(:question, survey_id: survey.id, question_type: qt)

      3.times { Fabricate(:answer, question_id: question.id) } unless question.text?
    end

    login_into_institution institution: content.institution, as: 'student'

    Fabricate(
      :enrollment,
      enrollable_id: @test_user.id,
      teach_id: content.teach_id, job: 'student'
    )

    visit teach_content_path(content.teach, content)

    assert page.has_css?('form.new_reply')

    assert_difference 'Reply.count', Question::TYPES.size do
      within('form.new_reply .form-group.radio_buttons') do
        first(:css, 'input[type="radio"]').click
      end

      within('form.new_reply .form-group.select') do
        select find('select option:nth-child(2)').text, from: find('select')[:id]
      end

      within('form.new_reply .form-group.text') do
        fill_in find('textarea')[:id], with: 'Some response'
      end

      find('form.new_reply .btn').click

      assert page.has_no_css?('form.new_reply')
    end
  end

  test 'should edit a survey' do
    content = Fabricate(:content)
    survey = Fabricate(:survey, content_id: content.id)

    login_into_institution institution: content.institution, as: 'student'

    Fabricate(
      :enrollment,
      enrollable_id: @test_user.id,
      teach_id: content.teach_id, job: 'student'
    )

    Question::TYPES.each do |qt|
      question = Fabricate(:question, survey_id: survey.id, question_type: qt)

      if question.text?
        Fabricate(
          :reply,
          user_id: @test_user.id,
          question_id: question.id,
          answer_id: nil, response: 'Some response'
        )
      else
        3.times { Fabricate(:answer, question_id: question.id) }

        Fabricate(
          :reply,
          user_id: @test_user.id,
          question_id: question.id,
          answer_id: question.answers.last.id
        )
      end
    end

    visit teach_content_path(content.teach, content)

    assert page.has_no_css?('form.edit_reply')

    all('a[data-remote][href$="/edit"]').each &:click

    assert page.has_no_css?('a[data-remote][href$="/edit"]')
    assert page.has_css?('form.edit_reply')

    assert_no_difference 'Reply.count' do
      within('form.edit_reply .form-group.radio_buttons') do
        first(:css, 'input[type="radio"]').click
      end

      within('form.edit_reply .form-group.select') do
        select find('select option:nth-child(2)').text, from: find('select')[:id]
      end

      within('form.edit_reply .form-group.text') do
        fill_in find('textarea')[:id], with: 'Some updated response'
      end

      find('form.edit_reply input.btn').click

      assert page.has_no_css?('form.edit_reply')
    end
  end

  test 'should upload a presentation' do
    login_into_institution as: 'student'

    homework = Fabricate(:homework)
    content = homework.content
    presentation = Fabricate.build(:presentation, homework_id: homework.id, user_id: nil)
    Fabricate(:enrollment, enrollable_id: @test_user.id, teach_id: content.teach_id)

    visit teach_content_path(content.teach, content)

    assert page.has_css?("#presentation_file_#{homework.to_param}")
    assert page.has_no_css?('.upload')

    assert_difference 'Presentation.count' do
      attach_file "presentation_file_#{homework.to_param}", presentation.file.path

      assert page.has_no_css?('.upload') # Wait until the file is uploaded
    end
  end
end
