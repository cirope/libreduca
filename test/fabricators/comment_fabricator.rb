Fabricator(:comment) do
  comment { Faker::Lorem.sentences(4).join("\n") }
  user_id { Fabricate(:user).id }
  commentable_id { Fabricate(:presentation).id }
  commentable_type 'Presentation'
end
