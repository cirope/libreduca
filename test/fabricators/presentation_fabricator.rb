Fabricator(:presentation) do
  file {
    Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/test.txt", 'text/plain', false
    )
  }
  user_id { Fabricate(:user).id }
  homework_id { Fabricate(:homework).id }
end
