require 'test_helper'

class SurveysTest < ActionDispatch::IntegrationTest
  include Integration::Login

  setup do
    institution = Fabricate(:institution)

    login_into_institution institution: institution, as: 'teacher'

    @content = Fabricate(:content) do
      teach_id do
        Fabricate(:teach) do
          course_id do
            Fabricate(:course) do
              grade_id { Fabricate(:grade, institution_id: institution.id).id }
            end.id
          end
        end.id
      end
    end

    Fabricate(
      :enrollment,
      teach_id: @content.teach_id,
      with_job: 'teacher',
      enrollable_id: @test_user.id,
      enrollable_type: @test_user.class.name
    )

    @survey = Fabricate(:survey, content_id: @content.id)
  end

  test 'should create a survey' do
    visit new_content_survey_path(@content)

    fill_in 'survey_name', with: @survey.name

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

    assert_difference ['Survey.count', 'Question.count', 'Answer.count'] do
      find('.btn-primary').click
    end
  end

  test 'should add questions of different types' do
    visit edit_content_survey_path(@content, @survey)

    click_link I18n.t('view.contents.surveys.new_question')

    Question::TYPES.reverse_each do |t|
      assert page.has_no_css?("[data-question-type=\"#{t}\"]")

      select(
        I18n.t("view.surveys.question_types.#{t}"),
        from: find('select[data-question-type-templates]')[:id]
      )

      assert page.has_css?("[data-question-type=\"#{t}\"]")
    end
  end
end
