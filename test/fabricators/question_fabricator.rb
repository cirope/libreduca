Fabricator(:question) do
  content { Faker::Lorem.sentence }
  question_type { Question::TYPES.sample }
  required false
  survey_id { Fabricate(:survey).id }
end
