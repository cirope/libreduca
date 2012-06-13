Fabricator(:user) do
  name { Faker::Name.first_name }
  lastname { Faker::Name.last_name }
  email { |attrs|
    Faker::Internet.email([attrs[:name], sequence(:user_id)].join(' '))
  }
  password { Faker::Lorem.sentence }
  password_confirmation { |attrs| attrs[:password] }
  role :admin
end