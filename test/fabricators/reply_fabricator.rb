Fabricator(:reply) do
  created_at { Time.zone.now }
  response nil
  question_id { Fabricate(:question).id }
  answer_id { |attrs| Fabricate(:answer, question_id: attrs[:question_id]).id }
  user_id { Fabricate(:user).id }
end
