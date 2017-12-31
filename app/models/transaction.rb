class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum status: %i[success error]

  validates_presence_of :amount, :transaction_type
end
