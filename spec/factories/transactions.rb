FactoryBot.define do
  factory :transaction do
    intent_id { 'bbb170ae0ab9ad0d1447a59472b9b320' }
    value_in_cents { 100000 }
    status { 'PAID' }
    paid_at { Time.parse("2022-02-20 18:41:11 -0500") }
    external_id { "0c7e9261-6b99-48aa-92f6-a1c878a37b90" }
    currency { 'CFL' }
  end
end