class AddAccountNumberToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :account_number, :string
    add_column :accounts, :obfuscated_account, :string
  end
end
