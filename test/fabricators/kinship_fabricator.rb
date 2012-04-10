Fabricator(:kinship) do
  kin { Kinship::TYPES.sample }
  user_id { Fabricate(:user).id }
  relative_id { Fabricate(:user).id }
end
