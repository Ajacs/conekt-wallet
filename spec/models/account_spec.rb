require 'rails_helper'



RSpec.describe Account , type: :model do

  #An account should belong to an user
  it {should belong_to(:user)}

  #An account should hace an user associated
  it { should validate_presence_of(:user)}

end