Fabricator(:vote) do
  user_id { Fabricate(:user).id }
  votable_id { Fabricate(:comment).id }
  votable_type 'Comment'
end
