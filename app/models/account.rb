class Account < ApplicationRecord
  belongs_to :user
  before_create :set_active_account

  #validations
  validates_presence_of :user

  def set_active_account
    self.available = true
  end
end
