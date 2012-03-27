Fabricator(:grade) do
  name { sequence(:grade_name) }
  school_id { Fabricate(:school).id }
end
