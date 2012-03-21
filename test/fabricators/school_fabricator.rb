Fabricator(:school) do
  name { Faker::Company.name }
  identification {
    [Faker::Address.state_abbr, sequence(:school_identification)].join(' - ')
  }
end
