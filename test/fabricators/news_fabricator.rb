Fabricator(:news) do
  title { "#{Faker::Lorem.words(10).join(' ')}" }
  description { Faker::Lorem.paragraph(5) }
  body { Faker::Lorem.paragraph(10) }
  published_at { I18n.l Time.now, format: :shorter }
  institution_id { Fabricate(:institution).id }
end
