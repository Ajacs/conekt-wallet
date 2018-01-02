require 'faker'

FactoryGirl.define do
  factory :user do
    name 'Adderly'
    lastname 'Jauregui'
    email Faker::Internet.unique.email
    password 'adderlyjc'
  end
end