class Account < ApplicationRecord
  belongs_to :user
  before_create :set_active_account

  #validations
  validates_presence_of :user, :account_type

  def set_active_account
    self.available = true
  end
end
