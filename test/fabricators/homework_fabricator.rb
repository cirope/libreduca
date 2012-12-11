Fabricator(:homework) do
  name { Faker::Name.name }
  description { Faker::Lorem.paragraph }
  closing_at { 2.days.from_now.to_date }
  content_id { Fabricate(:content).id }
end
