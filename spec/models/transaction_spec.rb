require 'rails_helper'



RSpec.describe Transaction , type: :model do

  #An account should belong to an user
  it { should belong_to(:user) }

  #A transaction should belog to an account
  it { should belong_to(:account) }

  #An account should hace an user associated
  #it { should validate_presence_of(:user)}

  #An account should have an account type (Root, User)
  #it { should validate_presence_of(:account_type)}
end