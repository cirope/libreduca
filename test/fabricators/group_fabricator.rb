Fabricator(:group) do
  name { Faker::Company.name }
  institution_id { Fabricate(:institution).id }
end
