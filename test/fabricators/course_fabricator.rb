Fabricator(:course) do
  name do
    "#{Faker::Lorem.words(rand(2).next).join(' ')} #{sequence(:course_name)}"
  end
  grade_id { Fabricate(:grade).id }
end
