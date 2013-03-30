module SurveysHelper
  def survey_path(survey)
    [@content || survey.content, survey]
  end

  def edit_survey_path(survey)
    polymorphic_path(survey_path(survey), action: :edit)
  end

  def show_question_type_select(form)
    options = Question::TYPES.map do |t|
      [t("view.surveys.question_types.#{t}"), t]
    end

    form.input(
      :question_type,
      collection: options,
      as: :select,
      label: false,
      input_html: {
        class: 'span11', data: { 'templates-url' => 'holder' }
      }
    )
  end
end
