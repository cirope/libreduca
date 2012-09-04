Fabricator(:question) do
  content { Faker::Lorem.sentence }
  survey_id { Fabricate(:survey).id }
end
