Fabricator(:setting) do
  name { Faker::Name.name }
  kind 'String'
  value 'Test'
  configurable_id { Fabricate(:institution).id }
  configurable_type 'Institution'
end
