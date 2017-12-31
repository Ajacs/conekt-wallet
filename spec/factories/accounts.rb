FactoryGirl.define do
  factory :account do
    user
    balance 2500.50
    available true
    account_type 'USER'
  end
end