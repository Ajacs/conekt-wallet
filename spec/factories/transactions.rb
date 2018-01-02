FactoryGirl.define do
  factory :transaction do
    account
    user
    transaction_type 0
    status_message ''
    destination_account 2
    amount 350.00
  end
end