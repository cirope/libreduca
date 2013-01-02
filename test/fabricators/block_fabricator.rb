Fabricator(:block) do
  content { Faker::Lorem.sentence }
  blockable_id { Fabricate(:page).id }
  blockable_type 'Page'
end
