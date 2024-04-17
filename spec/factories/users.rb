require 'ostruct'

FactoryBot.define do
  factory :user, class: OpenStruct do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end