Fabricator(:login) do
  ip { Faker::Internet.ip_v4_address }
  user_agent { Faker::Lorem.sentence }
  created_at { Time.now }
  user_id { Fabricate(:user).id }
end
