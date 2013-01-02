Fabricator(:news) do
  title { "#{Faker::Lorem.words(10).join(' ')}" }
  description { Faker::Lorem.paragraph(5) }
  body { Faker::Lorem.paragraph(10) }
  institution_id { Fabricate(:institution).id }
end
