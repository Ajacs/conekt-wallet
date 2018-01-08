class Transaction < ApplicationRecord
  audited
  belongs_to :user
  belongs_to :account

  enum transaction_status: %i[error pending success]

  enum transaction_target_type: %i[external internal]

  enum transaction_type: %i[fund income transference]

  validates_presence_of :amount, :transaction_type, :transaction_target_type

end
