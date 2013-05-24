Fabricator(:teach) do
  start { 2.days.ago.to_date }
  finish { 4.months.from_now.to_date }
  description { Faker::Lorem.sentences(4).join("\n") }
  course_id { Fabricate(:course).id }
end
