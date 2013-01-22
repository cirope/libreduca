Fabricator(:comment) do
  comment { Faker::Lorem.sentences(4).join("\n") }
  user_id { Fabricate(:user).id }
end

Fabricator(:comment_forum, from: :comment, class_name: :comment) do
  commentable_id { Fabricate(:forum).id }
  commentable_type 'Forum'
end

Fabricator(:comment_news, from: :comment, class_name: :comment) do
  commentable_id { Fabricate(:news).id }
  commentable_type 'News'
end
