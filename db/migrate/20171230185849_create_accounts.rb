class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :account_type
      t.float :balance
      t.boolean :available

      t.timestamps
    end
  end
end
