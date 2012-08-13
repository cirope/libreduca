Fabricator(:job) do
  job { Job::TYPES.sample }
  user_id { Fabricate(:user).id }
  institution_id { Fabricate(:institution).id }
end
