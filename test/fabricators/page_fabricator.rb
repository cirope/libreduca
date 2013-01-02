Fabricator(:page) do
  institution_id { Fabricate(:institution).id }
end