require 'faker'

class Account < ApplicationRecord
  belongs_to :user
  before_create :set_active_account, :set_account_number

  #validations
  validates_presence_of :user

  def set_active_account
    self.available = true
  end

  def set_account_number
    self.id = Faker::Number.unique.number(10).to_s
  end
end
