Fabricator(:teach) do
  start { Date.today }
  finish { 4.months.from_now.to_date }
  course_id { Fabricate(:course).id }
end
