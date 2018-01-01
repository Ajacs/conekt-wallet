class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum status:%i[error pending success]

  enum target_type: %i[internal external]

  validates_presence_of :amount, :transaction_type
end
