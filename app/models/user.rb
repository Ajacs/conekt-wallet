class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :accounts, foreign_key: :user_id
  has_many :transactions, foreign_key: :user_id

  #validations
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true
end
