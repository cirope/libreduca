Fabricator(:block) do
  content { Faker::Lorem.sentence }
  position 0
  blockable_id { Fabricate(:page).id }
  blockable_type 'Page'
end
