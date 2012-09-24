Fabricator(:image) do
  transient :raw_file_path

  name { Faker::Lorem.sentence }
  file do |attrs|
    path = "#{Rails.root}/test/fixtures/files/test.gif"

    attrs[:raw_file_path] ?
      path : Rack::Test::UploadedFile.new(path, 'image/gif', true)
  end
  institution_id { Fabricate(:institution).id }
end
