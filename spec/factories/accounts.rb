FactoryGirl.define do

  factory :account do
    user
    balance 2500.50
    available true
    account_type 'USER'
  end

  factory :gaccount, class: Account do
    user
    balance 0.0
    available true
    account_type 'GENERAL'
  end
end