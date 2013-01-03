Fabricator(:block) do
  content { Faker::Lorem.sentence }
  blockable_id { Fabricate(:institution).id }
  blockable_type 'Page'
end