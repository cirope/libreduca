Fabricator(:content) do
  title { Faker::Lorem.sentence }
  teach_id { Fabricate(:teach).id }
end
