Fabricator(:tagging) do
  tag_id { Fabricate(:tag).id }
  taggable_id { Fabricate(:news).id }
  taggable_type 'News'
end
