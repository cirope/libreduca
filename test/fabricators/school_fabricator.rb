Fabricator(:school) do
  name { Faker::Company.name }
  identification {
    [Faker::Address.state_abbr, sequence(:school_identification)].join(' - ')
  }
  district_id { Fabricate(:district).id }
end
