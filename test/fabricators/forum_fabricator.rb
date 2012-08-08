Fabricator(:forum) do
  name { "#{Faker::Lorem.words(2).join(' ')} #{sequence(:forum_name)}"}
  topic { Faker::Lorem.sentences(4).join("\n") }
  info { Faker::Lorem.sentences(4).join("\n") }
  user_id { Fabricate(:user).id }
  owner_id { Fabricate(:school).id }
  owner_type 'School'
end
