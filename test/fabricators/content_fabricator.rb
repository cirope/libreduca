Fabricator(:content) do
  title { Faker::Lorem.sentence }
  content { Faker::Lorem.sentences(10).join("\n") }
  teach_id { Fabricate(:teach).id }
end
