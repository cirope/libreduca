Fabricator(:forum) do
  name { "#{Faker::Lorem.words(2).join(' ')} #{sequence(:forum_name)}"}
  topic { Faker::Lorem.sentences(4).join("\n") }
  info { Faker::Lorem.sentence }
  user_id { Fabricate(:user).id }
  owner_id { Fabricate(:institution).id }
  owner_type 'Institution'
end
