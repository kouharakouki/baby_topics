FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number:10) }
    profile_image { Faker::Lorem.characters(number:20) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Date.today }
    phone_number { Faker::Number.number(digits: Faker::Number.between(from: 10, to: 11)) }
    user_name { Faker::Lorem.characters(number:10) }
    introduction { Faker::Lorem.characters(number:10) }
  end
end
