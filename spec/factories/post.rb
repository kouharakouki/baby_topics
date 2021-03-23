FactoryBot.define do
  factory :post do
    product_name { Faker::Lorem.characters(number: 8) }
    image_id { Faker::Lorem.characters(number: 20) }
    genre { 0 }
    price { 0 }
    reason_for_selection { Faker::Lorem.characters(number: 10) }
    good_point { Faker::Lorem.characters(number: 10) }
    bad_point { Faker::Lorem.characters(number: 10) }
    free_text { Faker::Lorem.characters(number: 10) }
    user
  end
end
