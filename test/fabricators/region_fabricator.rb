Fabricator(:region) do
  name { "#{Faker::Address.state} #{sequence(:region_name)}" }
end
