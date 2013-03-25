require 'test_helper'

class SurveysTest < ActionDispatch::IntegrationTest
  test 'should create a survey' do
    institution = Fabricate(:institution)

    login_into_institution institution: institution, as: 'janitor'

    content = Fabricate(:content) do
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

    survey = Fabricate.build(:survey, content_id: content.id)

    visit new_content_survey_path(content)

    fill_in 'survey_name', with: survey.name

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
end
