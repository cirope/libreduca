Fabricator(:comment) do
  comment { Faker::Lorem.sentences(4).join("\n") } 
  user_id { Fabricate(:user).id }
  forum_id { Fabricate(:forum).id }
end
