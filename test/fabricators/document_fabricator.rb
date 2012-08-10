Fabricator(:document) do
  name { "Document #{sequence(:document_name)}" }
  file {
    Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/test.txt", 'text/plain', false
    )
  }
  owner_id { Fabricate(:content).id }
  owner_type 'Content'
end
