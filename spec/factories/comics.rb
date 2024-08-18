FactoryBot.define do
  factory :comic do
    id { Faker::Number.number(digits: 10) }
    title { Faker::Lorem.sentence }
    thumbnail { Faker::Internet.url }
  end
end
