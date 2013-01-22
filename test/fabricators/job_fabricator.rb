Fabricator(:job) do
  job { Job::TYPES.sample }
  description { Faker::Lorem.sentence }
  user_id { Fabricate(:user).id }
  institution_id { Fabricate(:institution).id }
end
