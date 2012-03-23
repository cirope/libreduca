Fabricator(:district) do
  name { [Faker::Address.city, sequence(:district_name)].join(' ') }
  region_id { Fabricate(:region).id }
end
