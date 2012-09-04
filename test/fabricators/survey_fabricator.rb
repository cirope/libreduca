Fabricator(:survey) do
  name { Faker::Lorem.sentence }
  content_id { Fabricate(:content).id }
end
