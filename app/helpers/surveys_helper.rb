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
      :question_type, collection: options, as: :select, label: false, include_blank: false,
      input_html: {
        data: {
          'question-type-templates' => question_type_templates_in_json(form)
        }
      }
    )
  end

  def question_type_templates_in_json(form)
    templates = Question::TYPES.map do |t|
      [t, render("surveys/question_type_templates/#{t}", f: form)]
    end

    Hash[templates].to_json
  end
end
