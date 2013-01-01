Fabricator(:comment) do
  comment { Faker::Lorem.sentences(4).join("\n") }
  info { Faker::Lorem.sentences(4).join("\n") }
  user_id { Fabricate(:user).id }
  commentable_id { Fabricate(:forum).id }
  commentable_type 'Forum'
end
