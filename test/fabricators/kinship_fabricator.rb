Fabricator(:kinship) do
  kin { Kinship::KINDS.sample }
  user_id { Fabricate(:user).id }
  relative_id { Fabricate(:user).id }
end
