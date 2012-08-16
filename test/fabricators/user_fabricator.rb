Fabricator(:user) do
  transient :raw_avatar_path

  name { Faker::Name.first_name }
  lastname { Faker::Name.last_name }
  email { |attrs|
    Faker::Internet.email([attrs[:name], sequence(:user_id)].join(' '))
  }
  password { Faker::Lorem.sentence }
  password_confirmation { |attrs| attrs[:password] }
  avatar { |attrs|
    path = "#{Rails.root}/test/fixtures/files/test.gif"

    attrs[:raw_avatar_path] ?
      path : Rack::Test::UploadedFile.new(path, 'image/gif', true)
  }
  role :admin
end
