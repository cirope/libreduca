Fabricator(:school) do
  name { Faker::Company.name }
  identification do |attrs|
    [
      attrs[:name].gsub(/[^a-z\d\-]/i, '').downcase,
      sequence(:school_identification)
    ].join
  end
  district_id { Fabricate(:district).id }
end
