Fabricator(:participant) do
  user_id { Fabricate(:user).id }
  conversation_id { Fabricate(:conversation).id }
end
