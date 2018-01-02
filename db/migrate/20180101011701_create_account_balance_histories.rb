class CreateAccountBalanceHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :account_balance_histories do |t|
      t.references :account, foreign_key: true
      t.references :transaction, foreign_key: true
      t.float :last_balance
      t.float :new_balance

      t.timestamps
    end
  end
end
