class User < ApplicationRecord
  has_many :accounts

  #validations
  validates_presence_of :name, :email, :password_digest, :password_confirmation
end
