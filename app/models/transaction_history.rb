class TransactionHistory < ApplicationRecord
  belongs_to :transaction_source, foreign_key: 'transaction_id', class_name: 'Transaction'

  enum status: %i[error pending success]
end
