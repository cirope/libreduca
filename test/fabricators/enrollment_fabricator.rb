Fabricator(:enrollment) do
  teach_id { Fabricate(:teach).id }
  user_id { Fabricate(:user).id }
end
