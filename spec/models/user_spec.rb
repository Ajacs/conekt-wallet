require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:accounts)}

  #An user should have a name
  it { should validate_presence_of(:name) }

  #An user should have an email
  it { should validate_presence_of(:email) }

  #An user should have a password
  it { should validate_presence_of(:password_digest) }
end
