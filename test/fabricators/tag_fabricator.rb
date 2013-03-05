Fabricator(:tag) do
  name { "#{Faker::Lorem.words(2).join(' ')}" }
  category 'info'
  tagger_type 'News'
  institution_id { Fabricate(:institution).id }
end
