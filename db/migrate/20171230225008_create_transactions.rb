class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true
      t.integer :transaction_type
      t.float :amount
      t.integer :transaction_status
      t.string :status_message
      t.string :destination_account

      t.timestamps
    end
  end
end
