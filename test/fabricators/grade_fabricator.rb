Fabricator(:grade) do
  name { sequence(:grade_name) }
  institution_id { Fabricate(:institution).id }
end
