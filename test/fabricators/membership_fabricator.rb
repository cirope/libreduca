Fabricator(:membership) do
  user_id { Fabricate(:user).id }
  group_id { Fabricate(:group).id }
end
