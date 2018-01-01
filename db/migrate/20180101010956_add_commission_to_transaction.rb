class AddCommissionToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :commission, :float
    add_column :transactions,  :transaction_target_type, :string
  end
end
