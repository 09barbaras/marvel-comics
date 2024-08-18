# == Schema Information
#
# Table name: favorite_comics
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  comic_id   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :favorite_comic do
    comic_id { Faker::Number.number(digits: 10) }

    association :user
  end
end
