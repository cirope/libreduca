Fabricator(:answer) do
  content { Faker::Lorem.sentence }
  question_id { Fabricate(:question).id }
end
