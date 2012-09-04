Fabricator(:visit) do
  user_id { Fabricate(:user).id }
  visited_id { Fabricate(:content).id }
  visited_type 'Content'
end
