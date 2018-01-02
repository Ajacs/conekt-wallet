FactoryGirl.define do
  factory :transaction do
    account
    user
    transaction_type 0
    status_message ''
    destination_account 2
    amount 350.00
    transaction_target_type 0
    transaction_status 0
  end
end