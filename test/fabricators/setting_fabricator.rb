Fabricator(:setting) do
  name { Faker::Name.name }
  value { Faker::Lorem.sentence }
  configurable_id { Fabricate(:institution).id }
  configurable_type 'Institution'
end
