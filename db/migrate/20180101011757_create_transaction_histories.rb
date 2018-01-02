class CreateTransactionHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_histories do |t|
      t.references :transaction, foreign_key: true
      t.integer :transaction_status
      t.string :status_message

      t.timestamps
    end
  end
end
