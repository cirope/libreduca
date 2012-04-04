Fabricator(:score) do
  score { 100.0 * rand }
  multiplier { 100.0 * rand }
  description { Faker::Lorem.words(rand(3).next).join(' ') }
  teach_id { Fabricate(:teach).id }
  user_id { Fabricate(:user).id }
end
