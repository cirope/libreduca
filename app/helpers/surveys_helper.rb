module SurveysHelper
  def survey_path(survey)
    [@content || survey.content, survey]
  end

  def edit_survey_path(survey)
    polymorphic_path(survey_path(survey), action: :edit)
  end
end
