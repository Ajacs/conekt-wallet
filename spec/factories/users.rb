require 'faker'

FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@mail.com"
  end
end

FactoryGirl.define do
  factory :user do
    name 'Test'
    lastname 'Test'
    email { generate(:email) }
    password 'test'
  end
end