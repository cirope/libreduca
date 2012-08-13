Fabricator(:institution) do
  name { Faker::Company.name }
  identification do |attrs|
    [
      attrs[:name].gsub(/[^a-z\d\-]/i, '').downcase,
      sequence(:institution_identification)
    ].join
  end
  district_id { Fabricate(:district).id }
end
