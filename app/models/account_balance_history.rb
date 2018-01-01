class AccountBalanceHistory < ApplicationRecord
  belongs_to :account
  belongs_to :transaction_source, foreign_key: 'transaction_id', class_name: 'Transaction'
end
