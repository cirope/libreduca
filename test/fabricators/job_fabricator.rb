Fabricator(:job) do
  job { Job::TYPES.sample }
  user_id { Fabricate(:user).id }
  school_id { Fabricate(:school).id }
end
