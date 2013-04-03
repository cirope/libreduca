Fabricator(:conversation) do
  conversable_id { Fabricate(:presentation).id }
  conversable_type 'Presentation'
end
